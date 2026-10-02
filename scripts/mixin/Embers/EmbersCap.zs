#loader mixin

#mixin Mixin
#{targets: "teamroots.embers.tileentity.TileEntityBeamCannon"}
zenClass MixinBeamCannonCost{

    #mixin ModifyConstant{method: "<init>", constant: {doubleValue: 2000.0}}
    function LowerBeamCannonCost(value as double)as double{
        return 500.0 as double;
    }
}

#mixin Mixin
#{targets: "teamroots.embers.tileentity.TileEntityAutoHammer"}
zenClass MixinAutoHammerCap{

    #mixin ModifyConstant{method: "<init>", constant: {doubleValue: 12000.0}}
    function LowerAutoHammerCap(value as double)as double{
        return 1200.0 as double;
    }
}