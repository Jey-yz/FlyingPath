#reloadable
import scripts.libs.Data;
import scripts.libs.BlockMatcher;
import scripts.jei.inFireCraftJEI;
import crafttweaker.entity.IEntityItem;
import crafttweaker.data.IData;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import mods.zenutils.NetworkHandler;
import mods.zenutils.event.EntityItemDeathEvent;
import native.net.minecraft.util.SoundEvent;
import native.net.minecraft.util.SoundCategory;
import native.net.minecraft.util.ResourceLocation;
import native.net.minecraft.util.EnumParticleTypes;

zenClass InFireRecipe{
    val inp as IIngredient;
    val out as IItemStack;
    val time as int; 
    val isCustom as bool;
    val custom as function(IItemStack)IItemStack = null;

    zenConstructor(inp as IIngredient, out as IItemStack, time as int){
        this.inp = inp;
        this.out = out;
        this.time = time;
        this.isCustom = false; 
    }

    zenConstructor(inp as IIngredient, out as IItemStack, time as int,custom as function(IItemStack)IItemStack){
        this.inp = inp;
        this.out = out;
        this.time = time;
        this.isCustom = true;
        this.custom = custom;
    }
}

static recipes as InFireRecipe[] = [];
function addRecipe(out as IItemStack, inp as IIngredient, time as int = 1)as void{
    recipes += InFireRecipe(inp,out,time);
    inFireCraftJEI.createInFireRecipe(inp,out,time);
}
function addCustomRecipe(out as IItemStack, inp as IIngredient, custom as function(IItemStack)IItemStack, time as int = 1, tip as string = null)as void{
    recipes += InFireRecipe(inp,out,time,custom);
    inFireCraftJEI.createInFireRecipe(inp,out,time,tip);
}

events.onEntityItemDeath(function(event as EntityItemDeathEvent){
    val entity = event.item;
    val world = entity.world;
    if(entity.world.remote)return;
    if(event.damageSource.damageType!="inFire")return;
    if(!BlockMatcher.BlockMatcher("minecraft:fire").matcher()(world,entity.position))return;
    for recipe in recipes{
        if(recipe.inp.matches(entity.item)){
            var count = entity.nbt.dataGet("ForgeData.inFireCount")??0;
            if(count>=(recipe.isCustom?0:(-1+recipe.time))){
                val output = (!recipe.isCustom)?(recipe.out):(recipe.custom(entity.item));
                val out = output.mutable().copy().createEntityItem(entity.world, entity.posX as float, entity.posY as float, entity.posZ as float);
                out.motionX = 0.0;
                out.motionY = 0.0;
                out.motionZ = 0.0;
                entity.world.spawnEntity(out);
                NetworkHandler.sendToAllAround("InFireCraftParticle",entity.posX,entity.posY,entity.posZ,32.0,world.dimension,function(b){
                    b.writeData(Data.fromPos3f(entity.position3f));
                });
                if(entity.item.amount>recipe.inp.amount){
                    val newItem = (entity.item.mutable().copy()*(-recipe.inp.amount+entity.item.amount)).createEntityItem(entity.world, entity.posX as float, entity.posY as float, entity.posZ as float);
                    newItem.motionX = 0.0;
                    newItem.motionY = 0.0;
                    newItem.motionZ = 0.0;
                    newItem.setNBT(entity.nbt.ForgeData.dataSet(-1 as IData,"inFireCount"));
                    entity.world.spawnEntity(newItem);
                }
            }else{
                val newItem = entity.item.mutable().copy().createEntityItem(entity.world, entity.posX as float, entity.posY as float, entity.posZ as float);
                newItem.motionX = 0.0;
                newItem.motionY = 0.0;
                newItem.motionZ = 0.0;
                newItem.setNBT(entity.nbt.ForgeData.dataSet(count+1 as IData,"inFireCount"));
                entity.world.spawnEntity(newItem);
            }
            world.setBlockState(<blockstate:minecraft:air>,entity.position);
            world.native.playSound(null, entity.position.native, SoundEvent(ResourceLocation("block.fire.extinguish")), SoundCategory.BLOCKS, 0.2 as float, 1 as float);
        }
    }
});

NetworkHandler.registerServer2ClientMessage("InFireCraftParticle",function(player,b){
    val world = player.world;
    val pos = Data.toPos3f(b.readData());
    for i in 0 to 2+(world.random.nextInt(4)){
        world.native.spawnParticle(EnumParticleTypes.LAVA, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0);
    }
});