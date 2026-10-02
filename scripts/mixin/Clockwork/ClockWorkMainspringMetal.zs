#loader mixin
import native.lumaceon.mods.clockworkphase.lib.MechanicTweaker;
import native.lumaceon.mods.clockworkphase.api.MainspringMetal;
import native.lumaceon.mods.clockworkphase.api.MainspringMetalDictionary;
import mixin.CallbackInfo;


#mixin {targets: "lumaceon.mods.clockworkphase.api.MainspringMetalDictionary"}
zenClass MixinMainspringMetals{
    #mixin Inject{method:"init",at:{value:"TAIL"}}
    function addMetals(ci as CallbackInfo)as void{
        this0.mainspringMetals += MainspringMetal("ingotDraconium", 10000*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("blockDraconium", 90000*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("ingotDraconiumAwakened", 31250*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("gaiaIngot", 6666);
        this0.mainspringMetals += MainspringMetal("ingotFerramic", 400*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("blockFerramic", 3600*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("ingotMystic", 3750*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("blockMystic", 33750*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("ingotEnderium", 150*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("ingotDawnstone", 650*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
        this0.mainspringMetals += MainspringMetal("blockDawnstone", 5850*MechanicTweaker.MAINSPRING_TENSION_MUILTIPLIER);
    }
}
