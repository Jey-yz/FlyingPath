#loader mixin

#mixin Mixin
#{targets: "rustichromia.recipe.RecipeRegistry"}
zenClass MixinQuernRecipes{
    #mixin Redirect{method: "registerRecipesLate", at: {value: "INVOKE", target: "rustichromia/recipe/RecipeRegistry.addOreQuernRecipes()V"}}
    function noOreRecipes(r as native.rustichromia.recipe.RecipeRegistry)as void{
        // NO-OP
    }
}
