#loader mixin
#priority 3
import scripts.mixin.DynamoWill.TileDynamoWill;
import native.cofh.core.util.helpers.StringHelper;
import native.cofh.thermalexpansion.plugins.jei.Drawables;
import native.cofh.thermalexpansion.plugins.jei.dynamo.BaseFuelWrapper;
import native.mezz.jei.api.IGuiHelper;
import native.mezz.jei.api.gui.IDrawableAnimated.StartDirection;
import native.mezz.jei.api.gui.IDrawableStatic;
import native.mezz.jei.api.ingredients.IIngredients;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.client.Minecraft;

import native.java.util.ArrayList;
import native.java.util.List;

zenClass WillFuelWrapper extends BaseFuelWrapper{
    var inputs as ItemStack[];
	var power as int;

    zenConstructor(guiHelper as IGuiHelper, fuel as ItemStack, energy as int, power as int, uidIn as string){
		super();
        super.uId = uidIn;
        
		var recipeInputs as ItemStack[] = [];
		recipeInputs += fuel;

		this.inputs = recipeInputs;
		super.energy = energy;
		this.power = power;

		var progressDrawable as IDrawableStatic = Drawables.getDrawables(guiHelper).getScaleFill(Drawables.SCALE_ALCHEMY);
		var energyDrawable as IDrawableStatic = Drawables.getDrawables(guiHelper).getEnergyFill();

		super.durationFill = guiHelper.createAnimatedDrawable(progressDrawable, 40, StartDirection.TOP, true);
		super.energyMeter = guiHelper.createAnimatedDrawable(energyDrawable, 1000, StartDirection.BOTTOM, false);
    }

    function getIngredients(ingredients as IIngredients)as void{
		ingredients.setInputs(ItemStack.class, this.inputs);
	}

	function drawInfo(minecraft as Minecraft, width as int, height as int, x as int, y as int)as void{
		super.drawInfo(minecraft,width,height,x,y);
		minecraft.fontRenderer.drawString(StringHelper.formatNumber(power) + " RF/tick", 96, (height - 9) / 2+10, 0x808080);
	}
}