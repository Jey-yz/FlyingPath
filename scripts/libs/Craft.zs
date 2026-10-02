#reloadable
#priority 10000000
import scripts.jei.lightningTransformingJEI;
import scripts.libs.Misc;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.data.IData;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.oredict.IOreDictEntry;
import moretweaker.lightningcraft.LightningTransforming;
import mods.thermalexpansion.Factorizer;
import mods.prodigytech.rotarygrinder;
import mods.rustichromia.Quern;
import mods.thermalexpansion.Pulverizer;
import moretweaker.lightningcraft.LightningCrusher;
import native.java.lang.Object;

function map(pattern as string, map as IIngredient[string], spliter as string = ";")as IIngredient[][]{
    var out as IIngredient[][] = [];
    var IngredientsNow as IIngredient[] = [];
    for i in 0 to pattern.length{
        if(map.keys has pattern[i]){
            val IngredientNew = map[pattern[i]];
            IngredientsNow += IngredientNew;
        }else if(pattern[i]==spliter){
            out += IngredientsNow;
            IngredientsNow = [];
        }else{
            IngredientsNow += null;
        }
    }
    out += IngredientsNow;
    return out;
}

function compress(out as IItemStack, inp as IIngredient, amount as int = 9)as void{
    var a as IIngredient[] = [];
    if(amount==4){
        a=[inp,inp];
        recipes.addShaped(out,[a,a]);
    }else if(amount==9){
        a=[inp,inp,inp];
        recipes.addShaped(out,[a,a,a]);
    }
    Factorizer.addRecipeCombine(inp.items[0]*amount,out.items[0]);
}

function decompress(out as IItemStack, inp as IIngredient, amount as int = 9)as void{
    recipes.addShapeless(out*amount,[inp]);
    Factorizer.addRecipeSplit(inp.items[0],out.items[0]*amount);
}

function compressAndDecompress(out as IIngredient, inp as IIngredient, amount as int=9)as void{
    decompress(out.items[0],inp,amount);
    if(amount==4||amount==9)compress(inp.items[0],out,amount);
    Factorizer.addRecipeBoth(inp.items[0],out.items[0]*amount);
}

function ColliderBlocks(blocks as IIngredient[][])as IIngredient[][]{
    return [
        [blocks[0][0]??null,blocks[1][0]??null,blocks[2][0]??null],
        [blocks[0][1]??null,blocks[1][1]??null,blocks[2][1]??null],
        [blocks[0][2]??null,blocks[1][2]??null,blocks[2][2]??null]
    ] as IIngredient[][];
}

function addLore(ins as IIngredient, lore as string)as IIngredient{
    var result as IIngredient=null;
    for i in ins.items{
        val item as IItemStack = i;
        val lores = (isNull(i.tag)||isNull(i.tag.dataGet("display.Lore")))?[lore]as IData:(i.tag.dataGet("display.Lore")+[lore] as IData);
        var tag as IData={display:{Lore:lores}}as IData;
        if(i.hasTag){
            tag=i.tag.deepUpdate(tag);
        }
        if(isNull(result))result=item.updateTag(tag,false);
        else result=result|item.updateTag(tag,false);
    }
    result=result.only(function(item){
        return ins.matches(item);
    });
    return result;
}

function addLoreFake(ins as IIngredient, lore as string)as IIngredient{
    var result as IIngredient = null;
    for i in ins.items{
        val lores = (isNull(i.tag)||isNull(i.tag.dataGet("display.Lore")))?[lore]as IData:(i.tag.dataGet("display.Lore")+[lore] as IData);

    }
}

function reuse(ins as IIngredient)as IIngredient{
    return addLore(ins, game.localize("item.description.reuse")).reuse();
}

$ expand IIngredient $ Reuse()as IIngredient{
    return reuse(this);
}

function consume(ins as IIngredient)as IIngredient{
    return addLore(ins, game.localize("item.description.consume"));
}

$ expand IIngredient $ Consume()as IIngredient{
    return reuse(this);
}

static grindIndex as int = 0;
function grindSimple(out as IItemStack, inp as IIngredient, flag as int = 15, costs as int[] = [4000, 300, 5, 2147483647, 1000])as void{
    var index = 0;
    if((flag & 1) == 1){
        Pulverizer.addRecipe(out, inp.items[0], costs[index]);
        index += 1;
    }
    if((flag & 2) == 2){
        rotarygrinder.addRecipe(inp.items[0], out, costs[index]);
        index += 1;
    }
    if((flag & 4) == 4){
        Quern.add("QuernRecipe"~grindIndex, [inp], [out], costs[index], costs[index+1], costs[index+2]);
        index += 3;
    }
    if((flag & 8) == 8){
        LightningCrusher.add(out, inp);
    }
}

function addLightningTransform(out as IItemStack, ins as IIngredient[])as void{
    LightningTransforming.add(out,ins);
    lightningTransformingJEI.createLightningTransformingRecipe(out,ins);
}

//Not smart
function isRecipeMatched(recipe as IIngredient[], inputs as IItemStack[])as bool{
    var reci as int[IIngredient] = {};
    var ins as int[IItemStack] = {};
    for inp in recipe{
        if(!(reci.keys has inp*1)){
            reci[inp*1] = inp.amount;
        }else{
            reci[inp*1] = inp.amount+reci[inp*1];
        }
    }
    for inp in inputs{
        if(!(ins.keys has inp*1)){
            ins[inp*1] = inp.amount;
        }else{
            ins[inp*1] = inp.amount+ins[inp*1];
        }
    }
    for a in ins{
        for m in reci{
            if(ins[a]==0||reci[m]==0)continue;
            if(m.matches(a)){
                if(reci[m]>=ins[a]){
                    reci[m] = reci[m]-ins[a];
                    ins[a] = 0;
                }else{
                    ins[a] = ins[a]-reci[m];
                    reci[m] = 0;
                }
            }
        }
    }
    var sum = 0;
    for m,n in reci{
        sum+=n;
    }
    if(sum==0)return true;
    return false;
}
//If "check" is true, it will check whether the recipe is matched, if not, it'll add a barrier in the output 
function getRecipeRemainList(recipe as IIngredient[], inputs as IItemStack[], check as bool = false)as IItemStack[]{
    var reci as int[IIngredient] = {};
    var ins as int[IItemStack] = {};
    for inp in recipe{
        if(!(reci.keys has inp*1)){
            reci[inp*1] = inp.amount;
        }else{
            reci[inp*1] = inp.amount+reci[inp*1];
        }
    }
    for inp in inputs{
        if(!(ins.keys has inp*1)){
            ins[inp*1] = inp.amount;
        }else{
            ins[inp*1] = inp.amount+ins[inp*1];
        }
    }
    for a in ins{
        for m in reci{
            if(ins[a]==0||reci[m]==0)continue;
            if(m.matches(a)){
                if(reci[m]>=ins[a]){
                    reci[m] = reci[m]-ins[a];
                    ins[a] = 0;
                }else{
                    ins[a] = ins[a]-reci[m];
                    reci[m] = 0;
                }
            }
        }
    }
    var remain as IItemStack[] = [];
    for i,j in ins{
        if(j!=0)remain += i*j;
    }
    if(check){
        var sum = 0;
        for i,j in reci{
            sum+=j;
        }
        if(sum>0)remain += <minecraft:barrier>;
    }
    return remain;
}
//The same as the List one, and the barrier will be with the key "check"
function getRecipeRemainMap(recipe as IIngredient[], inputs as IItemStack[Object], check as bool = false)as IItemStack[Object]{
    var reci as int[IIngredient] = {};
    var ins as IItemStack[Object] = {};
    for inp in recipe{
        if(!(reci.keys has inp*1)){
            reci[inp*1] = inp.amount;
        }else{
            reci[inp*1] = inp.amount+reci[inp*1];
        }
    }
    for key,item in inputs{
        for m in reci{
            if((isNull(item)||item.amount==0))continue;
            if(m.matches(item*1)){
                if(reci[m]==0){
                    ins[key] = item;
                    continue;
                }
                if(reci[m]>=item.amount){
                    reci[m] = reci[m]-item.amount;
                    ins[key] = null;
                }else{
                    ins[key] = item*(item.amount-reci[m]);
                    reci[m] = 0;
                }
            }
        }
    }
    if(check){
        var sum = 0;
        for i,j in reci{
            sum+=j;
        }
        if(sum>0)ins["check"] = <minecraft:barrier>;
    }
    return ins;
}

// val rec as IIngredient[] = [<ore:ingotIron>*5,<ore:ingotGold>*3,<minecraft:iron_ingot>*3];
// val inp as IItemStack[string] = {"1":<minecraft:iron_ingot>*2,"2":<minecraft:gold_ingot>*4,"3":<minecraft:iron_ingot>*8};
// val result = getRecipeRemainMap(rec,inp,true) as IItemStack[string];
// for i,j in result{
//     (toString(i)+":"+(j.asString())).say();
// }
// getRecipeRemainList(rec,inp.values,true).asString().say();