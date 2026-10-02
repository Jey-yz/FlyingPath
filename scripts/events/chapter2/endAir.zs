#reloadable
import scripts.events.onBlockUpdate;
import scripts.libs.BlockMatcher;
import crafttweaker.data.IData;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.item.IItemStack;
import crafttweaker.util.IAxisAlignedBB;
import crafttweaker.entity.IEntityItem;
import mods.zenutils.NetworkHandler;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.util.EnumParticleTypes;

onBlockUpdate.onBlockUpdate(BlockMatcher.or(BlockMatcher.BlockMatcher("rustichromia:quern"),BlockMatcher.BlockMatcher("prodigytech:rotary_grinder")).matcher(),
    function(world as IWorld, pos as IBlockPos)as void{
        if(world.time%5 != 2)return;
        var canConvert = false;
        var chance = 0.0;
        if(BlockMatcher.BlockMatcher("rustichromia:quern").matcher()(world,pos)){
            val data = world.getBlock(pos).data;
            if(isNull(data))return;
            var isWorking = false;
            for i in 0 to 6{
                if((data.dataGet("mech_power"~i)??0.0)>0.1){
                    isWorking = true;
                    chance = data.dataGet("mech_power"~i).asDouble()/1200.0;
                }
            }
            if(!isWorking)return;
            if(isNull(data.dataGet("inventory.Items")))return;
            for i in data.dataGet("inventory.Items").asList(){
                if(ItemStack(i.native).isItemEqual(ItemStack(Item.getByNameOrId("minecraft:end_bricks"))))canConvert=true;
            }
        }else if(BlockMatcher.BlockMatcher("prodigytech:rotary_grinder").matcher()(world,pos)){
            val data = world.getBlock(pos).data;
            if(isNull(data))return;
            var isWorking = false;
            if((data.dataGet("ProcessTime")??0)>0){
                isWorking = true;
                chance = (data.dataGet("HotAir.Temperature")??(30 as IData)).asDouble()/4000.0;
            }
            if(!isWorking)return;
            if(isNull(data.dataGet("Items")))return;
            for i in data.dataGet("Items").asList(){
                if(ItemStack(i.native).isItemEqual(ItemStack(Item.getByNameOrId("minecraft:end_bricks"))))canConvert=true;
            }
        }
        if(!canConvert)return;
        NetworkHandler.sendToAllAround("EndAirGrindingParticle",0.5+pos.x,0.5+pos.y,0.5+pos.z,32.0,world.dimension,function(b){
            b.writeBlockPos(pos.add(0,1,0));
            b.writeDouble(chance);
        });
        if(world.random.nextDouble()>chance)return;
        val AABB = IAxisAlignedBB.create(pos.x as double,0.8+pos.y,pos.z as double,1.0+pos.x,2.0+pos.y,1.0+pos.z);
        val entities = world.getEntitiesWithinAABB(AABB);
        for e in entities{
            if(!(e instanceof IEntityItem))continue;
            val item as IEntityItem = e;
            if(<botania:vial:0>.matches(item.item)){
                item.item.mutable().shrink(1);
                val result = (<botania:manaresource:15>*1).createEntityItem(world, item.x as float, item.y as float, item.z as float);
                world.spawnEntity(result);
            }
        }
    },false,"EndAirGrinding");

NetworkHandler.registerServer2ClientMessage("EndAirGrindingParticle",function(player,b){
    val world = player.world;
    val pos = b.readBlockPos();
    val chance = b.readDouble();
    for i in 0 to (chance*200 as int){
        world.native.spawnParticle(EnumParticleTypes.TOWN_AURA, world.random.nextDouble()+pos.x, 0.8*world.random.nextDouble()+pos.y,world.random.nextDouble()+pos.z, 0.0, -0.5, 0.0, 0);
        if(world.random.nextBoolean())world.native.spawnParticle(EnumParticleTypes.FALLING_DUST, world.random.nextDouble()+pos.x, 0.5+0.5*world.random.nextDouble()+pos.y,world.random.nextDouble()+pos.z, 0.0, -0.5, 0.0, 0);
    }
});

<botania:manaresource:15>.addJEIDes("end_air");