#loader mixin
import native.teamroots.embers.tileentity.TileEntityBreaker;

#mixin Mixin
#{targets: "teamroots.embers.tileentity.TileEntityBreaker"}
zenClass MixinBreakerRedstoneControl{

    #mixin Redirect{method: func_73660_a, at: {value:"INVOKE", target: "teamroots/embers/tileentity/TileEntityBreaker.isActive()Z"}}
    function ReverseRedstoneControl(breaker as TileEntityBreaker)as bool{
        return !breaker.isActive() as bool;
    }

    #mixin ModifyConstant{method: func_73660_a, constant: {intValue: 20}}
    function fasterBreaker(value as int)as int{
        return 8 as int;
    }
}

#mixin Mixin
#{targets: "teamroots.embers.tileentity.TileEntityBreakerRenderer"}
zenClass MixinBreakerRedstoneControlRender{

    #mixin Redirect{method: render, at: {value:"INVOKE", target: "teamroots/embers/tileentity/TileEntityBreaker.isActive()Z"}}
    function ReverseRedstoneControl(breaker as TileEntityBreaker)as bool{
        return !breaker.isActive() as bool;
    }
}