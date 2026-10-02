#reloadable
import scripts.libs.Craft;
import crafttweaker.data.IData;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.util.IAxisAlignedBB;
import crafttweaker.entity.IEntityItem;
import crafttweaker.liquid.ILiquidStack;
import crafttweaker.liquid.ILiquidDefinition;
import crafttweaker.event.EntityJoinWorldEvent;
import native.net.minecraft.entity.item.EntityItem;
import native.com.google.common.base.Predicate;

zenClass LiquidTransRecipe{
    val liquidIn as ILiquidDefinition;
    val itemIn as IIngredient[];
    val consumeLiquid as bool;
    val liquidOut as ILiquidDefinition;
    val itemOut as IItemStack[];
    var chance as double = 100.0d;
    val action as function(IWorld,IBlockPos,IEntityItem[],IItemStack[string])void;

    function doOutPut(world as IWorld, pos as IBlockPos)as void{
        if(this.consumeLiquid)world.setBlockState(<blockstate:minecraft:air>,pos);
        if((world.random.nextDouble()*100.0)<=this.chance){
            val liquid = ((isNull(this.liquidOut)||isNull(this.liquidOut.block))?<blockstate:minecraft:air>:this.liquidOut.block.definition.defaultState);
            world.setBlockState(liquid,pos);
            for out in this.itemOut{
                world.spawnEntity(out.createEntityItem(world,pos));
            }
        }
    }

    function consumeInput(input as IEntityItem[],remain as IItemStack[string])as void{
        for i in input{
            val uuid = i.native.getCachedUniqueIdString();
            i.addTag("LiquidTransCD");
            if(remain.keys has uuid){
                var amount = 0;
                if(isNull(remain[uuid])){
                    amount = i.item.amount;
                }else{
                    amount = -remain[uuid].amount+i.item.amount;
                }
                i.item.mutable().shrink(amount);
            }
        }
    }

    zenConstructor(){
        this.liquidIn = null;
        this.itemIn = [];
        this.itemOut = [];
        this.liquidOut = null;
        this.consumeLiquid = true;
        this.action = function(world as IWorld, pos as IBlockPos, inp as IEntityItem[], remain as IItemStack[string])as void{
            this.consumeInput(inp,remain);
            this.doOutPut(world,pos);
        };
    }

    function setItemIn(itemIn as IIngredient[])as LiquidTransRecipe{
        this.itemIn = itemIn;
        return this;
    }

    function setLiquidIn(liquidIn as ILiquidStack)as LiquidTransRecipe{
        this.liquidIn = liquidIn.definition;
        return this;
    }

    function setItemOut(itemOut as IItemStack[])as LiquidTransRecipe{
        this.itemOut = itemOut;
        return this;
    }

    function setLiquidOut(liquidOut as ILiquidStack)as LiquidTransRecipe{
        this.liquidOut = liquidOut.definition;
        return this;
    }

    function setConsume(doConsume as bool)as LiquidTransRecipe{
        this.consumeLiquid = doConsume;
        if(!doConsume)this.liquidOut = this.liquidIn;
        return this;
    }

    function setChance(chance as double)as LiquidTransRecipe{
        this.chance = chance;
        return this;
    }

    function setAction(action as function(IWorld,IBlockPos,IEntityItem[],IItemStack[string])void)as LiquidTransRecipe{
        this.action = action;
        return this;
    }
}

static recipes as LiquidTransRecipe[] = [];
//If "consume" is false, you can only consume the items when the recipe is failed.
function createLiquidConvertRecipe(itemInp as IIngredient[], liquidInp as ILiquidStack, liquidOut as ILiquidStack, consume as bool =true, chance as double = 100.0)as LiquidTransRecipe{
    val recipe as LiquidTransRecipe = LiquidTransRecipe().setItemIn(itemInp).setLiquidIn(liquidInp).setChance(chance).setConsume(consume).setLiquidOut(liquidOut);
    return recipe;
}
function createItemConvertRecipe(itemInp as IIngredient[], liquidInp as ILiquidStack, itemOut as IItemStack[], consume as bool = true, chance as double = 100.0)as LiquidTransRecipe{
    val recipe as LiquidTransRecipe = LiquidTransRecipe().setItemIn(itemInp).setLiquidIn(liquidInp).setItemOut(itemOut).setChance(chance).setConsume(consume);
    return recipe;
}
function createBothConvertRecipe(itemInp as IIngredient[], liquidInp as ILiquidStack, itemOut as IItemStack[], liquidOut as ILiquidStack, consume as bool = true, chance as double = 100.0)as LiquidTransRecipe{
    val recipe as LiquidTransRecipe = LiquidTransRecipe().setItemIn(itemInp).setLiquidIn(liquidInp).setItemOut(itemOut).setChance(chance).setConsume(consume).setLiquidOut(liquidOut);
    return recipe;
}
//To add advanced functions, you may need to use the three functions above and ".addAction" on your own, then "addRecipe"
function addRecipe(recipe as LiquidTransRecipe)as void{
    recipes += recipe;
}

events.onEntityJoinWorld(function(event as EntityJoinWorldEvent){
    if(event.world.remote)return;
    if(!(event.entity instanceof IEntityItem))return;
    val itemEntity as IEntityItem = event.entity;
    var isIngrdient as bool = false;
    var possibleRecipes as LiquidTransRecipe[] = [];
    for recipe in recipes{
        for ing in recipe.itemIn{
            if(((ing*1).matches(itemEntity.item*1))){
                isIngrdient = true;
                possibleRecipes += recipe;
                break;
            }
        }
    }
    if(!isIngrdient)return;
    itemEntity.isInvulnerable = true;
    event.world.catenation()
        .sleepUntil(function(w, ctx) {
            val liquid = w.getBlock(itemEntity.position);
            if(isNull(liquid)||isNull(liquid.fluid))return false;
            return true;
    }).repeat(2147483647,function(builder){
        builder.run(function(w,c){
            if(itemEntity.native.age%4!=0){
                return;
            }
            if(itemEntity.tags has "LiquidTransCD"){
                itemEntity.removeTag("LiquidTransCD");
                return;
            }
            val liquid = w.getBlock(itemEntity.position);
            if(isNull(liquid)||isNull(liquid.fluid))return;
            var LiquidMatchedRecipes as LiquidTransRecipe[] = [];
            for recipe in possibleRecipes{
                if(!isNull(recipe.liquidIn)&&(recipe.liquidIn.name == liquid.fluid.name)){
                    LiquidMatchedRecipes += recipe;
                }
            }
            val Inputs as [EntityItem] = w.native.getEntitiesWithinAABB(EntityItem.class,IAxisAlignedBB.create(itemEntity.position),
                (function(e as EntityItem)as bool{
                    if(e.isDead)return false;
                    if(e.wrapper.tags has "LiquidTransCD")return false;
                    return true;
                })as Predicate);
            var inputMap as IItemStack[string] = {};
            for inp in Inputs{
                inputMap[inp.getCachedUniqueIdString()] = inp.getItem().wrapper;
            }
            for recipe in LiquidMatchedRecipes{
                val remain as IItemStack[string] = Craft.getRecipeRemainMap(recipe.itemIn,inputMap,true);
                if(!(remain.keys has "check")){
                    var inputs as IEntityItem[] = [];
                    for inp in Inputs{
                        inputs += inp.wrapper;
                    }
                    recipe.action(w,itemEntity.position,inputs,remain);
                    return;
                }
            }
        });
    }).start();
});

createLiquidConvertRecipe([<contenttweaker:blizzblock>,(<minecraft:packed_ice>*3).or(<minecraft:snow>*20)],<liquid:water>,<liquid:cryotheum>);
val batteries = (<lightningcraft:battery:*>.only(function(item as IItemStack)as bool{
    val data = item.tag;
    if(isNull(data)||isNull(data.StoredEnergy))return false;
    if(data.StoredEnergy>=50.0)return true;
    return false;
})).or(<projectred-expansion:charged_battery>);
var recipe2 as LiquidTransRecipe = createItemConvertRecipe([<collision:proton_empty>,batteries],<liquid:water>,[<collision:proton>]);
recipe2 = recipe2.setAction(function(world as IWorld, pos as IBlockPos, inp as IEntityItem[], remain as IItemStack[string])as void{
    var out as IItemStack = null;
    for i in inp{
        if(<projectred-expansion:charged_battery>.matches(i.item*1)){
            out = <projectred-expansion:empty_battery>;
            break;
        }else if(batteries.matches(i.item*1)){
            out = i.item.withTag(i.item.tag.dataSet(-50.0+i.item.tag.StoredEnergy,"StoredEnergy"));
            break;
        }
    }
    recipe2.consumeInput(inp,remain);
    world.performExplosion(null,pos.x,pos.y,pos.z,1,false,true);
    recipe2.doOutPut(world,pos);
    world.spawnEntity(out.createEntityItem(world,pos));
});
addRecipe(recipe2);