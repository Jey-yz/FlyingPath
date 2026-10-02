#loader preinit
#priority -1
#sideonly client
 
import native.net.minecraft.client.renderer.block.model.ModelResourceLocation;
import native.net.minecraftforge.client.model.ModelLoader;
import native.net.minecraftforge.client.event.ModelRegistryEvent;
import scripts.preinit.RitualDust;
 
events.register(function(event as ModelRegistryEvent) {
    ModelLoader.setCustomModelResourceLocation(RitualDust.dustItem, 0, ModelResourceLocation("contenttweaker:ritual_dust_0", "inventory"));
    ModelLoader.setCustomModelResourceLocation(RitualDust.dustItem, 1, ModelResourceLocation("contenttweaker:ritual_dust_1", "inventory"));
});