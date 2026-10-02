#reloadable
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onItemUpdate;
import crafttweaker.item.IItemStack;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.entity.IEntityEquipmentSlot;
import native.java.util.regex.Pattern;
import native.net.minecraft.entity.player.EntityPlayer;

events.onBlockBreak(function(event as crafttweaker.event.BlockBreakEvent){
    val world = event.world;
    if(world.remote)return;
    if(BlockMatcher.BlockMatcher("minecraft:tallgrass").blockMatcher()(event.block)){
        val player = event.player;
        val crystal as function(IItemStack)bool = function(item as IItemStack)as bool{
            //idk how to use regex, this's copied from botania.
            val pattern as Pattern = Pattern.compile("(?:(?:(?:[A-Z-_.:]|^)crystal)|(?:(?:[a-z-_.:]|^)Crystal))(?:[sA-Z-_.:]|$)");
            if(isNull(item))return false;
            if(!pattern.matcher(item.native.getTranslationKey()).find())return false;
            return true;
        };
        if(!crystal(player.mainHandHeldItem) && !crystal(player.offHandHeldItem))return;
        if((player.nbt.dataGet('abilities.flying')??0 as IData)==0)return;
        player.give(<contenttweaker:easter_egg>.withTag({variant:"youyihj"}));
    }
});

events.register(function(event as native.net.minecraftforge.event.entity.player.PlayerWakeUpEvent){
    val player as IPlayer = event.entityPlayer.wrapper;
    if(player.world.remote)return;
    val heldItem as function(IItemStack)bool = function(item as IItemStack)as bool{
        if(ItemMatcher.ItemMatcher([<rustichromia:cotton_candy_stick>,<rustichromia:cotton_candy>]).matcher()(item))return true;
        if(isNull(item))return false;
        val pattern as Pattern = Pattern.compile("(?:(?:(?:[A-Z-_.:]|^)dream)|(?:(?:[a-z-_.:]|^)Dream))(?:[a-zA-Z-_.:]|$)");
        if(pattern.matcher(item.native.getTranslationKey()).find())return true;
        return false;
    };
    if(!onItemUpdate.isHolding(player,heldItem))return;
    var chance = 5;
    if(onItemUpdate.isHolding(player,ItemMatcher.ItemMatcher([<rustichromia:cotton_candy_stick>,<rustichromia:cotton_candy>]).matcher()))chance *= 5;
    //Though its not Christmas
    val headItem = ItemMatcher.ItemMatcher(<botania:manaweavehelm>).matcher();
    if(headItem(player.getItemInSlot(crafttweaker.entity.IEntityEquipmentSlot.head())))chance *= 10;
    if(!(player.world.random.nextInt(100)<chance))return;
    player.give(<contenttweaker:easter_egg>.withTag({variant:"doremyswee"}));
});

events.register(function(event as crafttweaker.event.PlayerTickEvent){
    val world = event.player.world;
    if(world.remote)return;
    if(event.phase=="START")return;
    val player = event.player;
    if(player.isPotionActive(<potion:minecraft:glowing>)){
        val AABB = player.getBoundingBox().native;
        var flag = 0;
        var lightPos = IBlockPos.create(0,0,0);
        for i in IBlockPos.getAllInBox(IBlockPos.create((AABB.minX<0?-1:0)+AABB.minX,AABB.minY,(AABB.minZ<0?-1:0)+AABB.minZ),IBlockPos.create((AABB.maxX<0?-1:0)+AABB.maxX,AABB.maxY,(AABB.maxZ<0?-1:0)+AABB.maxZ)){
            if(BlockMatcher.or(BlockMatcher.BlockMatcher("embers:glow"),BlockMatcher.BlockMatcher("botania:manaflame")).matcher()(world,i)){
                flag = flag|1;
                lightPos = i;
                continue;
            }
            if(BlockMatcher.BlockMatcher("thermalfoundation:fluid_glowstone").matcher()(world,i)){
                flag = flag|2;
            }
        }
        if(flag==3){
            player.give(<contenttweaker:easter_egg>.withTag({variant:"raa"}));
            world.setBlockState(<blockstate:minecraft:air>,lightPos);
        }
    }
    if(player.isPotionActive(<potion:contenttweaker:sandwich_power>)&&player.world.time%10==4){
        if(onItemUpdate.isHolding(player,ItemMatcher.ItemMatcher(<contenttweaker:badge_surviving_dedebuff>).matcher())||onItemUpdate.isCarrying(player,ItemMatcher.ItemMatcher([<contenttweaker:force_of_life>,<contenttweaker:soul_of_challenger>]).matcher())){
            if(onItemUpdate.isCarrying(player,ItemMatcher.ItemMatcher(<contenttweaker:soul_of_challenger>).matcher())){
                player.removePotionEffect(<potion:contenttweaker:sandwich_power>);
                player.give(<contenttweaker:easter_egg>.withTag({variant:"darkmatterz"}));
            }else{
                var flag = 0;
                var ids as string[] = ["contenttweaker:badge_attacking","contenttweaker:badge_basic","contenttweaker:badge_surviving","contenttweaker:badge_buff"];
                for i in 0 to ids.length{
                    if(onItemUpdate.isCarrying(player,function(item as IItemStack)as bool{
                        if(isNull(item)||isNull(item.definition))return false;
                        if(item.definition.id.startsWith(ids[i]))return true;
                        return false;
                    })){
                        flag = flag | pow(2,i);
                    }
                }
                if(flag == 15){
                    player.removePotionEffect(<potion:contenttweaker:sandwich_power>);
                    player.give(<contenttweaker:easter_egg>.withTag({variant:"darkmatterz"}));
                }
            }
        }
    }

});
mods.jei.JEI.hide(<contenttweaker:easter_egg>);
<contenttweaker:easter_egg>.addTooltips(["easter_egg"]);
<contenttweaker:easter_egg>.addAdvancedTooltip(function(item){
    var out = "";
    if(isNull(item.tag))return out;
    val variant = item.tag.variant??"null";
    out = game.localize("item.description.easter_egg."~variant);
    return out;
});