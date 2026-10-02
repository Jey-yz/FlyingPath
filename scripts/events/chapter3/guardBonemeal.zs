#reloadable
import scripts.events.onItemUse;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IFacing;
import mods.zenutils.NetworkHandler;
import native.net.minecraft.init.Blocks;
import native.net.minecraft.init.Items;
import native.net.minecraft.block.BlockVine;
import native.net.minecraft.block.BlockStem;
import native.net.minecraft.block.BlockReed;
import native.net.minecraft.block.BlockCactus;
import native.net.minecraft.block.BlockLilyPad;
import native.net.minecraft.block.BlockNetherWart;

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<lightningcraft:material:8>).matcher(),BlockMatcher.allBlocks,
    function(world as IWorld, pos as IBlockPos, item as IItemStack, player as IPlayer, hand as string)as bool{
        val fPlayer = world.fakePlayer;
        var bonemealUsed as bool = false;
        for i in 0 to 2{
            if(isNull(fPlayer.simulateRightClickBlock(<minecraft:dye:15>,crafttweaker.entity.IEntityEquipmentSlot.mainHand(),pos,up,0.0,0.0,0.0).item)){
                bonemealUsed = true;
            }
        }
        if(bonemealUsed){
            item.mutable().shrink(1);
        }else{
            if(world.getBlock(pos).native instanceof BlockVine){
                var pos1 = pos.down();
                while(pos1.y>0){
                    if(!(world.getBlock(pos1).native instanceof BlockVine)){
                        break;
                    }
                    pos1 = pos1.down();
                }
                val vein = world.getBlock(pos).native as BlockVine;
                var meta = vein.getMetaFromState(world.getBlockState(pos).native);
                if(world.getBlockState(pos1).isReplaceable(world,pos1)){
                    for i,direction in [south,west,north,east]as IFacing[]{
                        if(vein.canPlaceBlockOnSide(world.native, pos1.native, direction.opposite().native)){
                            meta = meta|pow(2,i);
                        }
                    }
                    world.setBlockState(vein.getStateFromMeta(meta).wrapper,pos1);
                    item.mutable().shrink(1);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }else if(world.getBlock(pos).native instanceof BlockStem){
                val stem = world.getBlock(pos).native as BlockStem;
                val state = world.getBlockState(pos).native;
                if(!stem.canGrow(world.native,pos.native,state,false)){
                    var poses as IBlockPos[] = [];
                    val crop = (stem.getItem(world.native,pos.native,state).getItem()==Items.PUMPKIN_SEEDS)?(Blocks.PUMPKIN):Blocks.MELON_BLOCK;
                    for direction in [north,east,south,west]as IFacing[]{
                        val pos2 = pos.getOffset(direction,1);
                        if(world.getBlock(pos2).native==crop)return false;
                        if(world.getBlockState(pos2).isReplaceable(world,pos2)&&world.getBlockState(pos2.down()).native.isTopSolid()){
                            poses += pos2;
                        }
                    }
                    if(poses.length>0){
                        world.setBlockState(crop.getDefaultState().wrapper,poses[world.random.nextInt(poses.length)]);
                        item.mutable().shrink(1);
                        NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                            b.writeString(hand);
                        });
                        return true;
                    }
                }
            }else if(world.getBlock(pos).native instanceof BlockNetherWart){
                val wart = world.getBlock(pos).native as BlockNetherWart;
                if(wart.getMetaFromState(world.getBlockState(pos).native)<3){
                    world.setBlockState(wart.getStateFromMeta(3).wrapper,pos);
                    item.mutable().shrink(1);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }else if(world.getBlock(pos).native instanceof BlockCactus){
                var pos1 = pos.up();
                while(pos1.y<-1+world.getProvider().getHeight()){
                    if(!(world.getBlock(pos1).native instanceof BlockCactus)){
                        break;
                    }
                    pos1 = pos1.up();
                }
                val cactus = world.getBlock(pos).native as BlockCactus;
                if(world.getBlockState(pos1).isReplaceable(world,pos1) && cactus.canPlaceBlockAt(world.native,pos1.native)){
                    world.setBlockState(cactus.getDefaultState().wrapper,pos1);
                    item.mutable().shrink(1);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }else if(world.getBlock(pos).native instanceof BlockReed){
                var pos1 = pos.up();
                while(pos1.y<-1+world.getProvider().getHeight()){
                    if(!(world.getBlock(pos1).native instanceof BlockReed)){
                        break;
                    }
                    pos1 = pos1.up();
                }
                val reed = world.getBlock(pos).native as BlockReed;
                if(world.getBlockState(pos1).isReplaceable(world,pos1)){
                    world.setBlockState(reed.getDefaultState().wrapper,pos1);
                    item.mutable().shrink(1);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }else if(world.getBlock(pos).native instanceof BlockLilyPad){
                val lily = world.getBlock(pos).native as BlockLilyPad;
                var poses as IBlockPos[] = [];
                for direction in [north,east,south,west]as IFacing[]{
                    val pos2 = pos.getOffset(direction,1);
                    if(world.getBlockState(pos2).isReplaceable(world,pos2)&&lily.canBlockStay(world.native,pos2.native,world.getBlockState(pos2).native)){
                        poses += pos2;
                    }
                }
                if(poses.length>0){
                    world.setBlockState(lily.getDefaultState().wrapper,poses[world.random.nextInt(poses.length)]);
                    item.mutable().shrink(1);
                    NetworkHandler.sendTo("PlayerSwingHand",player,function(b){
                        b.writeString(hand);
                    });
                    return true;
                }
            }
        }
        return false;
    });
