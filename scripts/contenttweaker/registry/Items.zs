#loader contenttweaker
import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Item;

val badges as string[] = ["badge_attacking","badge_surviving","badge_buff","badge_basic",
    "badge_attacking_arrow","badge_attacking_missile","badge_attacking_star","badge_attacking_areathorn",
    "badge_surviving_invulnerable","badge_surviving_dedebuff","badge_surviving_hplock","badge_surviving_magicthorn",
    "badge_buff_strength","badge_buff_buffs","badge_buff_teleport","force_of_life","force_of_murder","force_of_aid","soul_of_challenger"];

//Surely "Soul of XX" is the name of the best souls(which are made of Abominable Energy and Eternal Energy), and it should be called as "Challenger's Soul"
//But since there isn't any better soul, I decide to call it as this.

for i in badges{
    val badge = VanillaFactory.createItem(i);
    badge.setMaxStackSize(1);
    if(i.startsWith("force")){
        badge.setRarity("UNCOMMON");
    }else if(i.startsWith("soul")){
        badge.setRarity("RARE");
    }
    badge.register();
}

val gaia_ingot = VanillaFactory.createItem("gaia_ingot");
gaia_ingot.register();

val sandwich = VanillaFactory.createItemFood("sandwich_ingot",10);
sandwich.setSaturation(1.5);
sandwich.setBeaconPayment(true);
sandwich.setAlwaysEdible(true);
sandwich.onItemFoodEaten = function(stack, world, player) {
    if (!world.isRemote()) {
        player.addPotionEffect(<potion:contenttweaker:sandwich_power>.makePotionEffect(20*60*20, 1));
    }
};
sandwich.register();

VanillaFactory.createItem("gunmu").register();

val aspect_lumium = VanillaFactory.createItem("aspectus_lumium");
aspect_lumium.register();
val aspect_enderium = VanillaFactory.createItem("aspectus_enderium");
aspect_enderium.register();

val life_essence = VanillaFactory.createItem("life_essence");
life_essence.register();

val gaia_essence = VanillaFactory.createItem("gaia_essence");
gaia_essence.register();

val elf_portal_key = VanillaFactory.createItem("alf_portal_key");
elf_portal_key.register();
val message_tablet = VanillaFactory.createItem("message_tablet");
message_tablet.register();

val redstone_seed = VanillaFactory.createItem("redstone_seeds");
redstone_seed.register();

val elf_powder = VanillaFactory.createItem("elf_powder");
elf_powder.register();

val rm_armour_gem_0 = VanillaFactory.createItem("redmatterarmourgem_deactived");
rm_armour_gem_0.setMaxStackSize(1);
val rm_armour_gem_1 = VanillaFactory.createItem("redmatterarmourgem_actived");
rm_armour_gem_1.setMaxStackSize(1);
rm_armour_gem_0.register();
rm_armour_gem_1.register();

val netherrack_dust = VanillaFactory.createItem("netherrack_dust");
netherrack_dust.register();
val endstone_dust = VanillaFactory.createItem("endstone_dust");
endstone_dust.register();

val hallowium_ingot = VanillaFactory.createItem("hallowium_ingot");
hallowium_ingot.register();