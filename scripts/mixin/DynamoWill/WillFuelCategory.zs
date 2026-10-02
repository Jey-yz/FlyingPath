#loader mixin
#priority 2
import scripts.mixin.DynamoWill.GuiDynamoWill;
import scripts.mixin.DynamoWill.WillFuelWrapper;
import scripts.mixin.DynamoWill.TileDynamoWill;
import native.cofh.core.inventory.ComparableItemStack;
import native.cofh.core.util.helpers.StringHelper;
import native.cofh.thermalexpansion.plugins.jei.Drawables;
import native.cofh.thermalexpansion.plugins.jei.dynamo.BaseFuelCategory;
import native.cofh.thermalexpansion.gui.client.dynamo.GuiDynamoEnervation;
import native.cofh.thermalexpansion.block.dynamo.ItemBlockDynamo;
import native.cofh.thermalexpansion.block.dynamo.BlockDynamo;
import native.mezz.jei.api.IGuiHelper;
import native.mezz.jei.api.IJeiHelpers;
import native.mezz.jei.api.IModRegistry;
import native.mezz.jei.api.gui.IGuiItemStackGroup;
import native.mezz.jei.api.gui.IRecipeLayout;
import native.mezz.jei.api.ingredients.IIngredients;
import native.mezz.jei.api.recipe.IRecipeCategoryRegistration;
import native.mezz.jei.api.recipe.IRecipeCategory;
import native.mezz.jei.api.recipe.IRecipeWrapper;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import mixin.CallbackInfo;

zenClass WillFuelCategory extends BaseFuelCategory{
    zenConstructor(guiHelper as IGuiHelper){
        super();
        super.background = guiHelper.createDrawable(GuiDynamoEnervation.TEXTURE, 26, 11, 70, 62, 0, 0, 16, 78);
		super.energyMeter = Drawables.getDrawables(guiHelper).getEnergyEmpty();
		super.durationEmpty = Drawables.getDrawables(guiHelper).getScale(Drawables.SCALE_ALCHEMY);
		super.localizedName = StringHelper.localize("tile.thermalexpansion.dynamo.will.name");
    }

    static initialize as function(IModRegistry)void = function(registry as IModRegistry)as void{
        val jeiHelpers as IJeiHelpers = registry.getJeiHelpers();
        val guiHelper as IGuiHelper = jeiHelpers.getGuiHelper();

        registry.addRecipes(getRecipes(guiHelper), "thermalexpansion.will");
        registry.addRecipeClickArea(GuiDynamoWill.GuiDynamoWill.class, 115, 35, 16, 16, "thermalexpansion.will");
        registry.addRecipeCatalyst(ItemStack(Item.getByNameOrId("thermalexpansion:dynamo"),1,6), "thermalexpansion.will");
    };

    static register as function(IRecipeCategoryRegistration)void = function(registry as IRecipeCategoryRegistration)as void{
        val jeiHelpers as IJeiHelpers = registry.getJeiHelpers();
        val guiHelper as IGuiHelper = jeiHelpers.getGuiHelper();

		registry.addRecipeCategories(WillFuelCategory(guiHelper) as IRecipeCategory);
    };

    static getRecipes as function(IGuiHelper)[WillFuelWrapper.WillFuelWrapper] =function(guiHelper as IGuiHelper)as [WillFuelWrapper.WillFuelWrapper]{
        var recipes = [] as [WillFuelWrapper.WillFuelWrapper];
        for i,j in (TileDynamoWill.TileDynamoWill.ItemFuel as int[ItemStack]){
            for a,b in (TileDynamoWill.TileDynamoWill.ItemPower as int[ItemStack]){
                if(ItemStack.areItemsEqual(i,a))recipes += WillFuelWrapper.WillFuelWrapper(guiHelper, (i as ItemStack), j as int, b as int, "thermalexpansion.will");
            }
        }
        return recipes;
    };

    function getUid()as string{
        return "thermalexpansion.will" as string;
    }

    function setRecipe(recipeLayout as IRecipeLayout, recipeWrapper as IRecipeWrapper, ingredients as IIngredients)as void{
        val inputs= ingredients.getInputs(ItemStack.class) as [[ItemStack]] ;
        val guiItemStacks as IGuiItemStackGroup = recipeLayout.getItemStacks();
        guiItemStacks.init(0, true, 33, 23);
		guiItemStacks.set(0, inputs[0]);
    }
}

#mixin Mixin
#{targets: "cofh.thermalexpansion.plugins.jei.JEIPluginTE"}
zenClass MixinDynamoJEI{
    #mixin Inject{method: "register", at = {value: "TAIL"}}
    function registerWillJEI(registry as IModRegistry, ci as CallbackInfo) as void{
        WillFuelCategory.initialize(registry);
    }

    #mixin Inject{method: "registerCategories", at = {value: "TAIL"}}
    function registerWillJEICategory(registry as IRecipeCategoryRegistration, ci as CallbackInfo) as void{
        WillFuelCategory.register(registry);
    }
}