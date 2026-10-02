#reloadable 
#priority 10000000
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.item.IItemStack;
import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockState;
import crafttweaker.block.IBlockStateMatcher;
import crafttweaker.data.IData;
import native.java.lang.Object;

zenClass BlockMatcher{
    var checker as function(IWorld,IBlockPos)bool;
    var blockStateChecker as function(IBlockState)bool = function(block as IBlockState)as bool{return false;};
    var blockChecker as function(IBlock)bool = function(block as IBlock)as bool{return false;};

    zenConstructor(checker as function(IWorld,IBlockPos)bool, blockchecker as function(IBlock)bool, blockstatechecker as function(IBlockState)bool){
        this.checker = checker;
        this.blockChecker = blockchecker;
        this.blockStateChecker = blockstatechecker;
    }

    zenConstructor(objs as Object[]){
        this.checker = function(world as IWorld, pos as IBlockPos)as bool{
            for i in objs{
                if(i instanceof IBlock){
                    if(BlockMatcher(i as IBlock).matcher()(world,pos))return true;
                }else if(i instanceof IBlockStateMatcher){
                    if(BlockMatcher(i as IBlockStateMatcher).matcher()(world,pos))return true;
                }else if(i instanceof IItemStack){
                    if(BlockMatcher(i as IItemStack).matcher()(world,pos))return true;
                }else{
                    if(BlockMatcher(i as string).matcher()(world,pos))return true;
                }
            }
            return false;
        };
    }

    zenConstructor(ibsm as IBlockStateMatcher){
        this.checker = function(world as IWorld, pos as IBlockPos)as bool{
            val blockstate = world.getBlockState(pos);
            return ibsm.matches(blockstate);
        }as function(IWorld,IBlockPos)bool;
        this.blockStateChecker = function(state as IBlockState)as bool{
            return ibsm.matches(state);
        }as function(IBlockState)bool;
    }

    zenConstructor(id as string){
        this.checker = BlockMatcher(id,-1).matcher();
        this.blockChecker = BlockMatcher(id,-1).blockMatcher();
    }

    zenConstructor(block as IBlock){
        this.checker = function(world as IWorld, pos as IBlockPos)as bool{
            val blockGet = world.getBlock(pos);
            if(isNull(block.definition)||isNull(blockGet.definition))return false;
            if(block.definition.id==blockGet.definition.id && block.meta==blockGet.meta)return true;
            return false;
        }as function(IWorld,IBlockPos)bool;
        this.blockChecker = function(blockin as IBlock)as bool{
            if(isNull(block.definition)||isNull(blockin.definition))return false;
            if(block.definition.id==blockin.definition.id && block.meta==blockin.meta)return true;
            return false;
        }as function(IBlock)bool;
    }

    zenConstructor(item as IItemStack){
        this.checker = function(world as IWorld, pos as IBlockPos)as bool{
            if(item.isBlock() && BlockMatcher(item.asBlock()).matcher()(world,pos))return true;
            return false;
        }as function(IWorld,IBlockPos)bool;
        this.blockChecker = function(block as IBlock)as bool{
            if(item.isBlock() && BlockMatcher(item.asBlock()).blockMatcher()(block))return true;
            return false;
        }as function(IBlock)bool;
    }

    zenConstructor(id as string, meta as int){
        this.checker = function(world as IWorld, pos as IBlockPos)as bool{
            val block = world.getBlock(pos);
            if((isNull(block)||isNull(block.definition))&&(id!="minecraft:air"))return false;
            if(id=="minecraft:air")return true;
            if(meta==-1&&(block.definition.id==id))return true;
            if((block.definition.id==id)&&(block.meta==meta))return true;
            return false;
        }as function(IWorld,IBlockPos)bool;
        this.blockChecker = function(block as IBlock)as bool{
            if((isNull(block)||isNull(block.definition))&&(id!="minecraft:air"))return false;
            if(id=="minecraft:air")return true;
            if(meta==-1&&(block.definition.id==id))return true;
            if((block.definition.id==id)&&(block.meta==meta))return true;
            return false;
        }as function(IBlock)bool;
    }

    function matcher() as function(IWorld,IBlockPos)bool{
        return this.checker;
    }

    function blockMatcher()as function(IBlock)bool{
        return this.blockChecker;
    }

    function blockStateMatcher()as function(IBlockState)bool{
        return this.blockStateChecker;
    }

    function check(world as IWorld, pos as IBlockPos)as bool{
        return this.checker(world,pos);
    }

    function checkBlock(block as IBlock)as bool{
        return this.blockChecker(block);
    }

    function checkState(state as IBlockState)as bool{
        return this.blockStateChecker(state);
    }
}

static allBlocks as function(IWorld, IBlockPos)bool = function(world as IWorld, pos as IBlockPos)as bool{
    return true;
};

function or(a as BlockMatcher, b as BlockMatcher)as BlockMatcher{
    return BlockMatcher(function(world as IWorld, pos as IBlockPos)as bool{
        return a.matcher()(world,pos) || b.matcher()(world,pos);
    },function(block as IBlock)as bool{
        return a.blockMatcher()(block) || b.blockMatcher()(block);
    },function(state as IBlockState)as bool{
        return a.blockStateMatcher()(state) || b.blockStateMatcher()(state);
    });
}
