#loader mixin
import native.java.lang.Object;
import native.java.util.ArrayList;
#mixin Mixin
#{targets: "teamroots.embers.tileentity.TileEntityDawnstoneAnvil"}
zenClass MixinDawnstoneAnvilHit{

    #mixin ModifyConstant{method: onHit, constant: {intValue: 1, ordinal:1}}
    function fasterHitsRequired(value as int)as int{
        return 4 as int;
    }
}

#mixin Mixin
#{targets: "teamroots.embers.recipe.RecipeRegistry"}
zenClass DawnstoneAnvilBreakDownDisabled{

    #mixin Redirect{method:"init",at:{value:"INVOKE",target:"java/util/ArrayList.add(Ljava/lang/Object;)Z", ordinal:118}}
    function cannotBreakDown(array as ArrayList, recipes as Object)as bool{
        // NO-OP
        return true;
    }
}