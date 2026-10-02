#loader preinit
#priority -1
#sideonly client
 
import native.net.minecraft.client.renderer.block.model.ModelResourceLocation;
import native.net.minecraftforge.client.model.ModelLoader;
import native.net.minecraftforge.client.event.ModelRegistryEvent;
import scripts.preinit.ClockworkGears;
 
events.register(function(event as ModelRegistryEvent) {
    for gear in ClockworkGears.gears{
        ModelLoader.setCustomModelResourceLocation(gear, 0, ModelResourceLocation(gear.registryName, "inventory"));
    }
    ModelLoader.setCustomModelResourceLocation(ClockworkGears.picture, 0, ModelResourceLocation(ClockworkGears.picture.registryName, "inventory"));
});