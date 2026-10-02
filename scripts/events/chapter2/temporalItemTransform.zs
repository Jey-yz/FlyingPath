#reloadable
import scripts.libs.Misc;
import scripts.libs.ItemMatcher;
import scripts.events.onItemUse;
import crafttweaker.item.IItemStack;
import crafttweaker.player.IPlayer;
import native.net.minecraft.item.ItemStack;
import native.shadows.click.util.FakePlayerUtil.UsefulFakePlayer;
import native.lumaceon.mods.clockworkphase.item.construct.ITemporalChange;
import native.lumaceon.mods.clockworkphase.item.construct.abstracts.ITimeSand;

onItemUse.onItemRightClick(function(item as IItemStack)as bool{
        if(isNull(item))return false;
        if(!(item.native.getItem() instanceof ITemporalChange))return false;
        if(!(item.native.getItem() instanceof ITimeSand))return false;
        val it as ITimeSand = item.native.getItem()as ITimeSand;
        if(!(it.getTimeSand(item.native) > 0))return false;
        return true;
    },
    function(item as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        if(!(player.native instanceof UsefulFakePlayer))return false;
        val it as ITemporalChange = item.native.getItem() as ITemporalChange;
        var newItem as ItemStack = ItemStack(it.getItemChangeTo());
        newItem.setTagCompound(item.native.getTagCompound());
        newItem.setItemDamage(item.native.getItemDamage());
        player.native.inventory.setInventorySlotContents(0, newItem);
        return true;
    }
);

for i in [<clockworkphase:clockwork_saber>,<clockworkphase:clockwork_axe>,<clockworkphase:clockwork_pickaxe>,<clockworkphase:clockwork_shovel>]{
    i.addJEIDes("clockwork.temporalchange");
}