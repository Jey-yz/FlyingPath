#loader mixin 
#norun
import native.vazkii.botania.api.corporea.CorporeaHelper;
import native.me.towdium.jecharacters.match.PinyinMatcher;
import native.java.lang.CharSequence;

#mixin Mixin
#{targets: "vazkii.botania.api.corporea.CorporeaHelper"}
zenClass MixinCorporeaPinyin{

    #mixin Static
    #mixin Redirect{method: "stacksMatch(Lnet/minecraft/item/ItemStack;Ljava/lang/String;)Z", at: {value:"INVOKE", target: "vazkii/botania/api/corporea/CorporeaHelper.equalOrContain(Ljava/lang/String;Ljava/lang/String;Z)Z", ordinal: 0}}
    function UsingPinyin(name as string, s as string, contains as bool)as bool{
        return CorporeaHelper.equalOrContain(name, s, contains) || PinyinMatcher.contains(name,s as CharSequence);
    }
}