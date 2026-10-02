#reloadable
#priority 100
import scripts.jei.beaconConversionJEI;
import scripts.events.onBlockUpdate;
import scripts.libs.BlockMatcher;
import crafttweaker.data.IData;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.util.IAxisAlignedBB;
import crafttweaker.entity.IEntityItem;

zenClass BeaconConversionRecipe{
    val inp as IIngredient;
    val out as IItemStack;
    val time as int; 
    val consume as bool;
    val chance as double;

    zenConstructor(inp as IIngredient, out as IItemStack, time as int, consumeBeacon as bool, consumeChance as double){
        this.inp = inp;
        this.out = out;
        this.time = time;
        this.consume = consumeBeacon;
        this.chance = consumeChance;
    }
}

static recipes as BeaconConversionRecipe[] = [];

function addRecipe(out as IItemStack, inp as IIngredient, time as int = 20, consume as bool = false, chance as double = -1.0)as void{
    recipes += BeaconConversionRecipe(inp,out,time,consume,chance);
    beaconConversionJEI.createBeaconConversionRecipe(inp,out,time,(consume)?chance:0);
}
// addRecipe(<botania:phantomink>,<botania:manaresource:15>,100,true,0.2);
onBlockUpdate.onBlockUpdate(BlockMatcher.BlockMatcher(<minecraft:beacon>).matcher(),
    function(world as IWorld, pos as IBlockPos)as void{
        val data = world.getBlock(pos).data;
        if(isNull(data.dataGet("Levels"))||isNull(data.dataGet("Primary")))return;
        if(data.dataGet("Levels").asInt()<1 || data.dataGet("Primary").asInt()<0)return;
        val AABB = IAxisAlignedBB.create(0.4+pos.x,pos.y as double,0.4+pos.z,0.6+pos.x,255.0+pos.y,0.6+pos.z);
        val entities = world.getEntitiesWithinAABB(AABB);
        for e in entities{
            if(!(e instanceof IEntityItem))continue;
            val item as IEntityItem = e;
            for recipe in recipes{
                if(recipe.inp.matches(item.item)){
                    if(isNull(item.nbt.dataGet("ForgeData.beaconConversion"))){
                        e.setNBT(item.nbt.ForgeData.dataSet(pow(2,-1+data.dataGet("Levels").asInt()),"beaconConversion"));
                    }else{
                        e.setNBT(item.nbt.ForgeData.dataSet(pow(2,-1+data.dataGet("Levels").asInt())+item.nbt.dataGet("ForgeData.beaconConversion") as IData,"beaconConversion"));
                    }
                    val end as double[] = [e.position3f.x+2.0*(-0.5+world.random.nextDouble()),e.position3f.y+world.random.nextDouble(),e.position3f.z+2.0*(-0.5+world.random.nextDouble())];
                    if(world.random.nextInt(3)==1)server.commandManager.executeCommandSilent(server,"particle endRod "~end[0]~' '~end[1]~' '~end[2]~" 0 0 0 0");
                    if(!isNull(item.nbt.dataGet("ForgeData.beaconConversion"))&&item.nbt.dataGet("ForgeData.beaconConversion").asInt()>=recipe.time){
                        e.setNBT(item.nbt.ForgeData.dataSet(0,"beaconConversion"));
                        item.item.mutable().shrink(recipe.inp.amount);
                        val result = (recipe.out*recipe.out.amount).createEntityItem(world, item.x as float, item.y as float, item.z as float);
                        world.spawnEntity(result);
                        if(recipe.consume && world.random.nextDouble()<=recipe.chance)world.destroyBlock(pos,false);
                    }
                    break;
                }
            }
        }
    },
false, "BeaconConversion");