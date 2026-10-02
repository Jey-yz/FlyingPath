#loader preinit
import native.net.minecraft.block.Block;
import native.net.minecraft.block.BlockRotatedPillar;
import native.net.minecraft.block.properties.IProperty;
import native.net.minecraft.block.properties.PropertyBool;
import native.net.minecraft.block.properties.PropertyEnum;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.block.state.BlockStateContainer;
import native.net.minecraft.block.material.Material;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemBlock;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.world.World;
import native.net.minecraft.world.IBlockAccess;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.util.EnumFacing;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraftforge.event.RegistryEvent;
import native.java.util.Random;

zenClass BlockComparator extends BlockRotatedPillar{
    static POWERED as PropertyBool = PropertyBool.create("powered");
    static AXIS as PropertyEnum = PropertyEnum.create("axis", EnumFacing.Axis.class);

    zenConstructor(material as Material){
        super(material);
        super.setHardness(2.0F);
        super.setDefaultState(super.getDefaultState()
				.withProperty(POWERED, false));
    }

    //createBlockState
    function func_180661_e()as BlockStateContainer{
        val properties as [IProperty] = [AXIS, POWERED] as [IProperty];
        return BlockStateContainer(this as Block, properties);
    }

    //getStateFromMeta
    function func_176203_a(meta as int) as IBlockState{
        return super.getStateFromMeta(meta).withProperty(POWERED, ((meta & 1) > 0));
    }

    //getMetaFromState
    function func_176201_c(state as IBlockState)as int{
        var i = 0;
        if(isNull(state))return super.getMetaFromState(state);
        i += super.getMetaFromState(state);
        if(!isNull(state.getValue(POWERED)) && (toString(state.getValue(POWERED))=="true"))i+=1;
        return i;
    }

    // updateTick
    function func_180650_b(world as World, pos as BlockPos, state as IBlockState, random as Random)as void{
        val meta as int = this.func_176201_c(state);
        var axis as int = meta;
        val isPowered = (!isNull(state.getValue(POWERED)) && (toString(state.getValue(POWERED))=="true"));
        if(isPowered)axis -= 1;
        axis = (axis & 12);
        if(axis == 0){
            val block1 = world.getBlockState(pos.up()).getBlock();
            val block2 = world.getBlockState(pos.down()).getBlock();
            if(!isNull(block1) && !isNull(block2) && Block.isEqualTo(block1,block2)){
                if(!isPowered){
                    world.setBlockState(pos,state.withProperty(POWERED, true), 3);
                    for facing in EnumFacing.values(){
                        world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
                    }
                }
            }else{
                if(isPowered){
                    world.setBlockState(pos,state.withProperty(POWERED, false), 3);
                    for facing in EnumFacing.values(){
                        world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
                    }                    
                }
            }
        }else if(axis == 4){
            val block1 = world.getBlockState(pos.east()).getBlock();
            val block2 = world.getBlockState(pos.west()).getBlock();
            if(!isNull(block1) && !isNull(block2) && Block.isEqualTo(block1,block2)){
                if(!isPowered){
                    world.setBlockState(pos,state.withProperty(POWERED, true), 3);
                    for facing in EnumFacing.values(){
                        world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
                    }
                }
            }else{
                if(isPowered){
                    world.setBlockState(pos,state.withProperty(POWERED, false), 3);
                    for facing in EnumFacing.values(){
                        world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
                    }                    
                }
            }
        }else if(axis == 8){
            val block1 = world.getBlockState(pos.north()).getBlock();
            val block2 = world.getBlockState(pos.south()).getBlock();
            if(!isNull(block1) && !isNull(block2) && Block.isEqualTo(block1,block2)){
                if(!isPowered){
                    world.setBlockState(pos,state.withProperty(POWERED, true), 3);
                    for facing in EnumFacing.values(){
                        world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
                    }
                }
            }else{
                if(isPowered){
                    world.setBlockState(pos,state.withProperty(POWERED, false), 3);
                    for facing in EnumFacing.values(){
                        world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
                    }                    
                }
            }
        }
    }

    // neighborChanged
    function func_189540_a(state as IBlockState, world as World, pos as BlockPos, block as Block, fromPos as BlockPos)as void{
        world.scheduleUpdate(pos, this as Block, 2);
    }

    //getWeakPower
    function func_180656_a(state as IBlockState, access as IBlockAccess, pos as BlockPos, facing as EnumFacing)as int{
        if(!isNull(state.getValue(POWERED)) && !isNull(state.getValue(AXIS)) && (toString(state.getValue(POWERED))=="true") && facing.getAxis()!=state.getValue(AXIS))return 15;
        return 0;
    }

    //getStrongPower
    function func_176211_b(state as IBlockState, access as IBlockAccess, pos as BlockPos, facing as EnumFacing)as int{
        if(!isNull(state.getValue(POWERED)) && !isNull(state.getValue(AXIS)) && (toString(state.getValue(POWERED))=="true") && facing.getAxis()!=state.getValue(AXIS))return 15;
        return 0;
    }

    //onBlockAdded
    function func_176213_c(world as World, pos as BlockPos, state as IBlockState)as void{
        for facing in EnumFacing.values(){
            world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
        }
    }

    //breakBlock
    function func_180663_b(world as World, pos as BlockPos, state as IBlockState)as void{
        for facing in EnumFacing.values(){
            world.notifyNeighborsOfStateChange(pos.offset(facing), this as Block, false);
        }
    }

    //canProvidePower
    function func_149744_f(state as IBlockState)as bool{
        return true;
    }

    function getStateForPlacement(world as World, pos as BlockPos, facing as EnumFacing, hitx as float, hity as float, hitz as float, meta as int, player as EntityLivingBase, hand as EnumHand)as IBlockState{
        val axis as EnumFacing.Axis = facing.getAxis();
        var powered as bool = false;
        if(axis == EnumFacing.Axis.Y){
            val block1 = world.getBlockState(pos.up()).getBlock();
            val block2 = world.getBlockState(pos.down()).getBlock();
            if(!isNull(block1) && !isNull(block2) && Block.isEqualTo(block1,block2)){
                powered = true;
            }
        }else if(axis == EnumFacing.Axis.X){
            val block1 = world.getBlockState(pos.east()).getBlock();
            val block2 = world.getBlockState(pos.west()).getBlock();
            if(!isNull(block1) && !isNull(block2) && Block.isEqualTo(block1,block2)){
                powered = true;
            }
        }else if(axis == EnumFacing.Axis.Z){
            val block1 = world.getBlockState(pos.north()).getBlock();
            val block2 = world.getBlockState(pos.south()).getBlock();
            if(!isNull(block1) && !isNull(block2) && Block.isEqualTo(block1,block2)){
                powered = true;
            }
        }
        return this.getStateFromMeta(meta).withProperty(AXIS, axis).withProperty(POWERED, powered);
    }

}

static Comparator as Block = BlockComparator(Material.ROCK).setTranslationKey("contenttweaker.block_comparator").setRegistryName("contenttweaker", "block_comparator");
static ComparatorItem as ItemBlock = ItemBlock(Comparator).setTranslationKey("contenttweaker.block_comparator").setRegistryName("contenttweaker", "block_comparator");

events.register(function(event as RegistryEvent.Register) {
    val registryName = event.name.toString();
    if (registryName == "minecraft:blocks") {
        event.registry.register(Comparator);
    }else if (registryName == "minecraft:items") {
        event.registry.register(ComparatorItem);
    }
});
