#loader mixin
#priority -1
import scripts.mixin.DynamoWill.TileDynamoWill;
import native.cofh.thermalexpansion.block.dynamo.BlockDynamo;
import native.cofh.thermalexpansion.block.dynamo.ItemBlockDynamo;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoSteam;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoMagmatic;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoCompression;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoReactant;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoEnervation;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoNumismatic;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.tileentity.TileEntity;
import native.net.minecraft.world.World;
import native.net.minecraftforge.fml.common.registry.GameRegistry;
import mixin.CallbackInfo;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "cofh.thermalexpansion.block.dynamo.BlockDynamo"}
zenClass MixinNewDynamo{
    #mixin Shadow
    static enable as bool[];
    static itemBlock as ItemBlockDynamo;

    #mixin Inject{method: "preInit", at = {value: "RETURN"}}
    function preinitDynamoWill(cir as CallbackInfoReturnable) as void{
        TileDynamoWill.TileDynamoWill().initialize();
        enable[6] = true;
    }

    #mixin Inject{method: "initialize", at = {value: "HEAD"}}
    function initializeDynamoWill(cir as CallbackInfoReturnable)as void{
        val dynamoWill = itemBlock.setDefaultTag(ItemStack(this0,1),BlockDynamo.Type.WILL.getMetadata());
    }

    #mixin Overwrite
    function createTileEntity(world as World, state as IBlockState)as TileEntity{
        val meta = state.getBlock().getMetaFromState(state);
        if (meta >= BlockDynamo.Type.values().length) {
			return null;
		}else{
            if(meta==0){
                return TileDynamoSteam();
            }else if(meta==1){
                return TileDynamoMagmatic();
            }else if(meta==2){
                return TileDynamoCompression();
            }else if(meta==3){
                return TileDynamoReactant();
            }else if(meta==4){
                return TileDynamoEnervation();
            }else if(meta==5){
                return TileDynamoNumismatic();
            }else if(meta==6){
                return TileDynamoWill.TileDynamoWill();
            }
        }
        return null;
    }
}

