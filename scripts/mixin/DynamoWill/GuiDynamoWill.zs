#loader mixin
#sideonly client
#priority 10
import native.cofh.thermalexpansion.init.TEProps;
import native.cofh.thermalexpansion.gui.container.dynamo.ContainerDynamoEnervation;
import native.cofh.thermalexpansion.gui.client.dynamo.GuiDynamoBase;
import native.cofh.core.init.CoreProps;
import native.cofh.core.gui.GuiContainerCore;
import native.cofh.core.gui.element.ElementDualScaled;
import native.cofh.core.gui.element.ElementEnergyStored;
import native.net.minecraft.util.ResourceLocation;
import native.net.minecraft.client.gui.inventory.GuiContainer;
import native.net.minecraft.entity.player.InventoryPlayer;
import native.net.minecraft.tileentity.TileEntity;


zenClass GuiDynamoWill extends GuiDynamoBase{
    static TEXTURE as ResourceLocation = ResourceLocation("thermalexpansion:textures/gui/dynamo/enervation.png");
  
    zenConstructor(inventory as InventoryPlayer, tile as TileEntity){
        super(ContainerDynamoEnervation(inventory, tile), tile, inventory.player, TEXTURE);
        super.generateInfo("tab.thermalexpansion.dynamo.will");
    }

    function func_73866_w_()as void {
        super.initGui();
        super.addElement(ElementEnergyStored(this as GuiContainerCore, 80, 18, super.baseTile.getEnergyStorage()));
        super.duration = super.addElement((ElementDualScaled(this as GuiContainerCore, 115, 35)).setSize(16, 16).setTexture("cofh:textures/gui/elements/scale_flux.png", 32, 16));
  }
}
