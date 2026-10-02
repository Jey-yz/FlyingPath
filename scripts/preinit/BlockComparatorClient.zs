#loader preinit
#priority -1
#sideonly client

import native.net.minecraft.client.renderer.block.model.ModelResourceLocation;
import native.net.minecraftforge.client.model.ModelLoader;
import native.net.minecraftforge.client.event.ModelRegistryEvent;
import scripts.preinit.BlockComparator;
import scripts.preinit.BlockComparatorAdvanced;

events.register(function(event as ModelRegistryEvent) {
    ModelLoader.setCustomModelResourceLocation(BlockComparator.ComparatorItem, 0, ModelResourceLocation(BlockComparator.ComparatorItem.registryName, "inventory"));
    ModelLoader.setCustomModelResourceLocation(BlockComparatorAdvanced.ComparatorAdvancedItem, 0, ModelResourceLocation(BlockComparatorAdvanced.ComparatorAdvancedItem.registryName, "inventory"));
});
