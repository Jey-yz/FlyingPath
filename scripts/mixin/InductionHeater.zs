#loader mixin
import native.exter.foundry.tileentity.TileEntityInductionHeater;
import mixin.CallbackInfoReturnable;

#mixin Mixin
#{targets: "exter.foundry.tileentity.TileEntityInductionHeater$HeatProvider"}
zenClass MixinInductionHeater{

    #mixin Redirect{method:"provideHeat",at:{value:"INVOKE", target:"exter/foundry/tileentity/TileEntityInductionHeater.useFoundryEnergy(IZ)I"}}
    function lowerMaxTemp(tile as TileEntityInductionHeater, consumption as int,douse as bool)as int{
        if(consumption>(200000*3/2000))return tile.useFoundryEnergy(200000*3/2000,true);
        return tile.useFoundryEnergy(consumption,true);
    }
}