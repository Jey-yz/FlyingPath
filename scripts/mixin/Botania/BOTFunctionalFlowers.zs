#loader mixin
import native.com.google.common.base.Predicate;
import native.java.lang.Object;
import native.java.lang.Comparable;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.block.Block;
import native.net.minecraft.block.properties.IProperty;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.block.state.pattern.BlockStateMatcher;
import native.net.minecraft.init.Blocks;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.tileentity.TileEntity;
import native.vazkii.botania.api.recipe.IElvenItem;
import native.vazkii.botania.api.state.BotaniaStateProps;
import native.vazkii.botania.api.state.enums.QuartzVariant;
import native.vazkii.botania.api.state.enums.BiomeStoneVariant;
import native.vazkii.botania.common.block.ModFluffBlocks;
import native.vazkii.botania.common.block.decor.quartz.BlockSpecialQuartz;
import native.mezz.jei.api.ingredients.IIngredients;
import native.mezz.jei.api.ingredients.VanillaTypes;
import native.knightminer.ceramics.blocks.BlockClayHard;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "vazkii.botania.common.block.subtile.functional.SubTileMarimorphosis"}
zenClass MixinMarimorphosis{

    #mixin ModifyArg{method: "getCoordsToPut", at: {value:"INVOKE", target: "net/minecraft/block/Block.isReplaceableOreGen(Lnet/minecraft/block/state/IBlockState;Lnet/minecraft/world/IBlockAccess;Lnet/minecraft/util/math/BlockPos;Lcom/google/common/base/Predicate;)Z"}}
    function ModifyCoords(matcher as Predicate)as Predicate{
        return (function(state as IBlockState) as bool{
            val matcher = BlockStateMatcher.forBlock(Blocks.STONE);
            if(matcher.apply(state))return true;
            if(state.getBlock() instanceof BlockSpecialQuartz){
                if(state.getBlock()==ModFluffBlocks.blazeQuartz)return false;
                val variant as QuartzVariant = state.getValue(BotaniaStateProps.QUARTZ_VARIANT) as QuartzVariant;
                if(variant != QuartzVariant.PILLAR_X && variant != QuartzVariant.PILLAR_Y && variant != QuartzVariant.PILLAR_Z)return false;
                return true;
            }
            return false;
        }) as Predicate;
    }

    #mixin Inject{method:"getStoneToPut", at:{value:"HEAD"}, cancellable:true}
    function ModifyStoneType(coords as BlockPos, cir as CallbackInfoReturnable)as void{
        val quartz as Block = this0.supertile.getWorld().getBlockState(coords).getBlock() as Block;
        if(quartz instanceof BlockSpecialQuartz){
            if(quartz == ModFluffBlocks.elfQuartz){
                val rand as int = this0.supertile.getWorld().rand.nextInt(3) as int;
                if(rand<2){
                    cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[rand]));
                }else{
                    cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[4]));
                }
            }else if(quartz == ModFluffBlocks.darkQuartz){
                cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[2]));
            }else if(quartz == ModFluffBlocks.lavenderQuartz){
                cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[3]));
            }else if(quartz == ModFluffBlocks.sunnyQuartz){
                cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[5]));
            }else if(quartz == ModFluffBlocks.manaQuartz){
                cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[6]));
            }else if(quartz == ModFluffBlocks.redQuartz){
                cir.setReturnValue(ModFluffBlocks.biomeStoneA.getDefaultState().withProperty(BotaniaStateProps.BIOMESTONE_VARIANT, BiomeStoneVariant.values()[7]));
            }
        }
    }

}

#mixin Mixin
#{targets: "vazkii.botania.common.block.subtile.functional.SubTileOrechidIgnem"}
zenClass MixinOrechidIgnem{

    #mixin Overwrite
    function getCost()as int{
        return 200;
    }

    #mixin Overwrite
    function canOperate()as bool{
        return true;
    }

    #mixin Overwrite
    function getReplaceMatcher()as Predicate{
        return (function(state as IBlockState)as bool{
            if(state.getBlock() == Blocks.NETHERRACK)return true;
            if((state.getBlock() instanceof BlockClayHard) && state.getValue(BlockClayHard.TYPE)==BlockClayHard.ClayTypeHard.LAVA_BRICKS)return true;
            return false;
        } as Predicate);
    }
}

#mixin Mixin
#{targets: "vazkii.botania.client.integration.jei.orechid.OrechidIgnemRecipeWrapper"}
zenClass MixinOrechidIgnemJEI{

    function getIngredients(ingredients as IIngredients)as void{
        val inputs = [ItemStack(Blocks.NETHERRACK, 64), ItemStack(Item.getByNameOrId("ceramics:clay_hard"),64,5)] as [ItemStack];
        val input = [inputs] as [[ItemStack]];
        ingredients.setInputLists(VanillaTypes.ITEM, input);
        ingredients.setOutputLists(VanillaTypes.ITEM, this0.outputStacks);
    }
}