#loader contenttweaker
import mods.contenttweaker.VanillaFactory;
import mods.randomtweaker.cote.IPotion;

var sandwich_power as IPotion = VanillaFactory.createPotion("sandwich_power", 0xF9F110);
sandwich_power.instant=false;
sandwich_power.beneficial=true;
sandwich_power.shouldRender=false;
sandwich_power.shouldRenderHUD=false;
sandwich_power.performEffect = function(living, amplifier) {
    if(!living.world.remote) {
        if(!living.isPotionActive(<potion:minecraft:haste>)){
            living.addPotionEffect(<potion:minecraft:haste>.makePotionEffect(10,2));
        }
        if(!living.isPotionActive(<potion:minecraft:poison>)){
            living.addPotionEffect(<potion:minecraft:poison>.makePotionEffect(10,4));
        }
        if(!living.isPotionActive(<potion:minecraft:saturation>)){
            living.addPotionEffect(<potion:minecraft:saturation>.makePotionEffect(10,0));
        }
        if(living.health>2.0)living.health = 1.0;
    }
};
sandwich_power.register();