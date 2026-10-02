#loader contenttweaker
import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Block;
import mods.randomtweaker.cote.ISubTileEntityFunctional;

var oreEnderium = VanillaFactory.createBlock("ore_enderium", <blockmaterial:rock>);
oreEnderium.setBlockHardness(2.0);
oreEnderium.setBlockResistance(10.0);
oreEnderium.setToolLevel(2);
oreEnderium.register();

var oreLumium = VanillaFactory.createBlock("ore_lumium", <blockmaterial:rock>);
oreLumium.setBlockHardness(1.5);
oreLumium.setBlockResistance(5.0);
oreLumium.setToolLevel(2);
oreLumium.setLightValue(1.0);
oreLumium.register();

var oreSignalum = VanillaFactory.createBlock("ore_signalum", <blockmaterial:rock>);
oreSignalum.setBlockHardness(0.3);
oreSignalum.setBlockResistance(1.0);
oreSignalum.setToolLevel(1);
oreSignalum.register();

var emberBlock = VanillaFactory.createBlock("block_embercrystal",<blockmaterial:rock>);
emberBlock.setToolLevel(1);
emberBlock.setBlockHardness(0.5);
emberBlock.setLightValue(0.3);
emberBlock.register();

var pulseBlock = VanillaFactory.createBlock("block_pulse",<blockmaterial:rock>);
pulseBlock.setToolLevel(1);
pulseBlock.setBlockHardness(2.0);
pulseBlock.beaconBase = true;
pulseBlock.register();

//Not Married
var marired as ISubTileEntityFunctional = VanillaFactory.createSubTileFunctional("marired", 0xD23232);
marired.range=2;
marired.maxMana=1000;
marired.register();

var elvenFrame = VanillaFactory.createBlock("frame_elven", <blockmaterial:iron>);
elvenFrame.setBlockHardness(5.0);
elvenFrame.setBlockResistance(10.0);
elvenFrame.setToolLevel(2);
elvenFrame.setTranslucent(true);
elvenFrame.setFullBlock(false);
elvenFrame.setLightOpacity(0);
elvenFrame.setLightValue(0.4);
elvenFrame.setBlockLayer("TRANSLUCENT");
elvenFrame.register();

val blizzBlock = VanillaFactory.createBlock("blizzblock",<blockmaterial:iron>);
blizzBlock.setLightValue(0.3);
blizzBlock.setBlockHardness(3.0);
blizzBlock.setBlockResistance(10.0);
// blizzBlock.setSlipperiness(-0.2f);//It's fun, but too weird
blizzBlock.setSlipperiness(1.03f);
blizzBlock.register();

val blitzBlock = VanillaFactory.createBlock("blitzblock",<blockmaterial:iron>);
blitzBlock.setLightValue(0.5);
blitzBlock.setBlockHardness(0.1);
blitzBlock.setBlockResistance(5.0);
blitzBlock.setToolLevel(0);
blitzBlock.register();

val basalzBlock = VanillaFactory.createBlock("basalzblock",<blockmaterial:iron>);
basalzBlock.setLightValue(0.1);
basalzBlock.setBlockHardness(40.0);
basalzBlock.setBlockResistance(10.0);
basalzBlock.register();

val te_demon_core = VanillaFactory.createActualTileEntity(1);
te_demon_core.register();
var demon_core = VanillaFactory.createExpandBlock("demon_core", <blockmaterial:rock>);
demon_core.axisAlignedBB=mods.contenttweaker.AxisAlignedBB.create(0.0,0.0,0.0,1.0,0.1875,1.0);
demon_core.fullBlock=false;
demon_core.lightValue=8;
demon_core.lightOpacity=0;
demon_core.translucent = true;
demon_core.blockLayer = "TRANSLUCENT";
demon_core.tileEntity = te_demon_core;
demon_core.register();

val pure_hallow = VanillaFactory.createBlock("pure_hallow", <blockmaterial:clay>);
pure_hallow.setBlockHardness(0.0);
pure_hallow.setBlockResistance(0.0);
pure_hallow.setToolLevel(0);
pure_hallow.setTranslucent(true);
pure_hallow.setFullBlock(false);
pure_hallow.setLightOpacity(0);
pure_hallow.setLightValue(1.0);
pure_hallow.setBlockLayer("TRANSLUCENT");
pure_hallow.setDropHandler(function(drops, world, position, state, fortune){
    drops.clear();
    return;
});
pure_hallow.register();

var oreHallowium = VanillaFactory.createBlock("ore_hallowium", <blockmaterial:rock>);
oreHallowium.setBlockHardness(2.0);
oreHallowium.setToolLevel(3);
oreHallowium.setLightValue(0.5);
oreHallowium.register();