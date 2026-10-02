#loader redstoneweed
import native.net.minecraft.init.Items;
import native.net.minecraft.init.Blocks;
import native.net.minecraft.block.Block;
import native.net.minecraft.block.BlockCrops;
import native.net.minecraft.world.World;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemSeeds;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.block.state.IBlockState;
import native.java.util.Random;
import native.net.minecraftforge.event.RegistryEvent;
import native.vazkii.botania.common.block.ModFluffBlocks;
import native.vazkii.botania.common.block.decor.quartz.BlockSpecialQuartz;
import native.vazkii.botania.api.state.BotaniaStateProps;
import native.vazkii.botania.api.state.enums.QuartzVariant;

zenClass RedstoneWeed extends BlockCrops {
    zenConstructor() {
        super();
    }

    //canSustainBush
    function func_185514_i(state as IBlockState)as bool{
        if(state.getBlock() != ModFluffBlocks.redQuartz)return false;
        val variant as QuartzVariant = state.getValue(BotaniaStateProps.QUARTZ_VARIANT);
        if(variant != QuartzVariant.PILLAR_X && variant != QuartzVariant.PILLAR_Y && variant != QuartzVariant.PILLAR_Z)return false;
        return true;
    }

    //updateTick
    function func_180650_b(worldIn as World, pos as BlockPos, state as IBlockState, rand as Random)as void{

    }

    //grow
    function grow(worldIn as World, pos as BlockPos, state as IBlockState)as void{
        var i = super.getAge(state)+1;
        if(i>super.getMaxAge()){
            i = super.getMaxAge();
        }
        worldIn.setBlockState(pos, super.withAge(i), 2);
    }

    // canUseBonemeal
    function func_180670_a(world as World, rand as Random, pos as BlockPos, state as IBlockState) as bool {
        return false;
    }

    //canBlockStay
    function func_180671_f(worldIn as World, pos as BlockPos, state as IBlockState)as bool{
        val soil = worldIn.getBlockState(pos.down());
        if(!(soil.getBlock() instanceof BlockSpecialQuartz))return false;
        val variant as QuartzVariant = soil.getValue(BotaniaStateProps.QUARTZ_VARIANT);
        if(variant != QuartzVariant.PILLAR_X && variant != QuartzVariant.PILLAR_Y && variant != QuartzVariant.PILLAR_Z)return false;
        return true;
    }

    // //dropBlockAsItemWithChance
    // function func_180653_a(world as World, pos as BlockPos, state as IBlockState, chance as float, fortune as int)as void{
    //     super.dropBlockAsItemWithChance(world, pos, state, chance, fortune);
    // }

    // getSeed
    function func_149866_i() as Item {
        return Item.getByNameOrId("contenttweaker:redstone_seeds");
    }

    // getCrop
    function func_149865_P() as Item {
        return Items.REDSTONE;
    }

}

static crops as Block = RedstoneWeed().setRegistryName("contenttweaker", "redstone_weed");
static seeds as Item = ItemSeeds(crops, ModFluffBlocks.redQuartz).setTranslationKey("contenttweaker.redstone_seeds").setRegistryName("contenttweaker", "redstone_seeds");

events.register(function(event as RegistryEvent.Register) {
    val registryName = event.name.toString();
    if (registryName == "minecraft:blocks") {
        event.registry.register(crops);
    }else if (registryName == "minecraft:items") {
        event.registry.register(seeds);
    }
});
