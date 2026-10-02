#reloadable
import scripts.events.onItemUpdate;
import scripts.libs.ItemMatcher;
import crafttweaker.event.BlockBreakEvent;
import crafttweaker.event.EntityJoinWorldEvent;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.player.IPlayer;
import crafttweaker.item.IItemStack;
import crafttweaker.entity.IEntityItem;
import crafttweaker.text.ITextComponent;
import crafttweaker.enchantments.IEnchantmentDefinition;
import mods.zenutils.DataUpdateOperation.OVERWRITE;
import mods.zenutils.event.EntityItemDeathEvent;

events.onBlockBreak(function(event as BlockBreakEvent){
    if(event.world.remote)return;
    val player = event.player;
    var pickaxe = player.mainHandHeldItem;
    if(!isNull(pickaxe)&&!isNull(pickaxe.definition)&&pickaxe.definition.id=="contenttweaker:dice_pickaxe"){
        val Enchantments = pickaxe.enchantments;
        if(event.world.random.nextInt(2)==0){
            val random = event.world.random.nextInt(100);
            if(random<25){
                pickaxe.mutable().addEnchantment(<enchantment:minecraft:silk_touch>.makeEnchantment(1));
                event.world.catenation().then(function(world,c){
                    if(<contenttweaker:dice_pickaxe>.matches(player.mainHandHeldItem))player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(),removeEnchantment(pickaxe,<enchantment:minecraft:silk_touch>));
                }).start();
                player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.silk_touch"));
            }else if(random<50){
                pickaxe.mutable().addEnchantment(<enchantment:minecraft:fortune>.makeEnchantment(random%6+5));
                event.world.catenation().then(function(world,c){
                    if(<contenttweaker:dice_pickaxe>.matches(player.mainHandHeldItem))player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(),removeEnchantment(pickaxe,<enchantment:minecraft:fortune>));
                }).start();
                player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.fortune"));
            }else if(random<70){
                player.addPotionEffect(<potion:minecraft:haste>.makePotionEffect(100,3));
                player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.haste"));
            }else if(player.isPotionActive(<potion:contenttweaker:sandwich_power>)||onItemUpdate.isCarrying(player,ItemMatcher.ItemMatcher([<contenttweaker:force_of_aid>,<contenttweaker:soul_of_challenger>]).matcher())){
                player.sendStatusMessage(game.localize("chat.dice_pickaxe.sandwich"));
                player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.sandwich"));
                return;
            }else if(random<80){
                player.addPotionEffect(<potion:minecraft:mining_fatigue>.makePotionEffect(30,2));
                player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.mining_fatigue"));
            }else if(random<97){
                player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.cancel"));
                event.cancel();
            }else{
                event.world.catenation().sleep(1).run(function(world,c){
                    player.dropItem(false);
                    player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.dice_pickaxe.drop"));
                }).start();
            }
        }
    }
});

events.onEntityJoinWorld(function(event as EntityJoinWorldEvent){
    if(event.world.remote)return;
    if(!(event.entity instanceof IEntityItem))return;
    val itemEntity as IEntityItem = event.entity;
    if(!<contenttweaker:dice_pickaxe>.matches(itemEntity.item))return;
    itemEntity.native.setPickupDelay(8);
    itemEntity.native.lifespan = 2147483647;
    event.world.catenation()
        .sleepUntil(function(w, ctx) {
            if (!itemEntity.native.addedToWorld || !itemEntity.alive) {
                ctx.catenation.stop();
            }
            if (itemEntity.posY<0) {
                return true;
            } else {
                return false;
            }
    }).then(function(w,c){
        if(itemEntity.native.addedToWorld || itemEntity.alive){
            itemEntity.hasNoGravity = true;
            itemEntity.motionY = 0.2;
            itemEntity.world.catenation().sleepUntil(function(w,c){
                if (!itemEntity.native.addedToWorld || !itemEntity.alive) {
                    c.catenation.stop();
                }
                if (itemEntity.posY>5) {
                    return true;
                } else {
                    return false;
                }
            }).then(function(w,c){
                if(itemEntity.native.addedToWorld || itemEntity.alive){
                    itemEntity.motionY = 0.0;
                }
            }).start();
        }
    }).start();
});

onItemUpdate.onItemUpdate(ItemMatcher.ItemMatcher(<contenttweaker:dice_pickaxe>).matcher(),
    function(item as IItemStack, player as IPlayer, slot as int)as void{
        player.native.replaceItemInInventory(slot,removeEnchantment(removeEnchantment(item,<enchantment:minecraft:silk_touch>),<enchantment:minecraft:fortune>).native);
    });

function removeEnchantment(item as IItemStack, enchantment as IEnchantmentDefinition)as IItemStack{
    if(isNull(item))return item;
    if(!item.isEnchanted)return item;
    val Ench = item.tag.ench;
    var newEnch as IData = [];
    for i in Ench.asList(){
        if(i.id.asInt() == enchantment.id)continue;
        newEnch += [i];
    }
    return item.withTag(item.tag.deepUpdate({ench:newEnch} as IData,{ench: OVERWRITE}));
}

<contenttweaker:dice_pickaxe>.addTooltip(game.localize("item.description.dice_pickaxe"));
<contenttweaker:dice_pickaxe>.addShiftTooltips(["dice_pickaxe"]as string[]);