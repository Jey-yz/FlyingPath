#loader mixin
#sideonly client
import scripts.mixin.DynamoWill.TileDynamoWill;
import native.cofh.core.gui.GuiContainerCore;
import native.cofh.core.gui.element.tab.TabInfo;
import native.cofh.core.gui.element.tab.TabBase;
import native.cofh.core.util.helpers.StringHelper;

#mixin Mixin
#{targets: "cofh.thermalexpansion.gui.client.dynamo.GuiDynamoBase"}
zenClass MixinDynamoInfo{

    #mixin ModifyArg{method: "func_73866_w_", at: {value: "INVOKE", target: "cofh/core/gui/element/tab/TabInfo.<init>(Lcofh/core/gui/GuiContainerCore;Ljava/lang/String;)V"}}
    function RemoveInfo(gui as GuiContainerCore, infoString as string)as string{
        // val GuiDynamo as native.cofh.thermalexpansion.gui.client.dynamo.GuiDynamoBase = gui;
        if(this0.baseTile instanceof TileDynamoWill.TileDynamoWill){
            return this0.myInfo + "";
        }
        return (this0.myInfo + "\n\n" + StringHelper.localize("tab.thermalexpansion.dynamo.0")) as string;
    }
}