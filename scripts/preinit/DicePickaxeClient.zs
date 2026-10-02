#loader preinit
#priority -1
#sideonly client
 
import native.net.minecraft.client.renderer.block.model.ModelResourceLocation;
import native.net.minecraftforge.client.model.ModelLoader;
import native.net.minecraftforge.client.event.ModelRegistryEvent;
import scripts.preinit.DicePickaxe;
 
events.register(function(event as ModelRegistryEvent) {
    ModelLoader.setCustomModelResourceLocation(DicePickaxe.pickaxe, 0, ModelResourceLocation(DicePickaxe.pickaxe.registryName, "inventory"));
});