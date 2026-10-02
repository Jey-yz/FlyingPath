#reloadable
import scripts.libs.ItemMatcher;
import crafttweaker.data.IData;
import crafttweaker.item.IItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.text.ITextComponent;
import mods.randomtweaker.botania.ElvenTradeEvent;
import mods.randomtweaker.botania.PoolTradeEvent;
import native.net.minecraft.util.text.ITextComponent as nativeTextComponent;

events.onElvenTrade(function(event as ElvenTradeEvent){
    var inputs = event.input;
    val world = IWorld.getFromID(0);
    val enabled = (world.getCustomWorldData().dataGet("elventradeEnabled")??(false as IData)).asBool();
    if(inputs.length<1)return;
    for i in inputs{
        if(ItemMatcher.or(ItemMatcher.ItemMatcher(<contenttweaker:alf_portal_key>),ItemMatcher.ItemMatcher(<minecraft:written_book>)).matcher()(i)) {
            if(ItemMatcher.ItemMatcher(<minecraft:written_book>).matcher()(i)){
                if(enabled){
                    event.output = [<contenttweaker:message_tablet>.withTag({translanted:"chat.alf_message_4"})];
                }
                world.setCustomWorldData(world.getCustomWorldData().dataSet(true,"elventradeEnabled"));
                return;
            }
            if(ItemMatcher.ItemMatcher(<contenttweaker:alf_portal_key>).matcher()(i)){
                if(enabled){
                    event.output = [<contenttweaker:message_tablet>.withTag({translanted:"chat.alf_message_2"})];
                }
                return;
            }
        }
    }
    if(!enabled){
        val tile = event.alfPortal;
        val player = tile.world.getClosestPlayer(0.5+tile.pos.x,0.5+tile.pos.y,0.5+tile.pos.z,32.0,false);
        player.sendRichTextStatusMessage(ITextComponent.fromTranslation("chat.alf_message_3"),true);

        event.cancel();
    }
});

events.onPoolTrade(function(event as PoolTradeEvent){
    var input = event.input.item;
    var pos = event.blockPos;
    var world = event.world;
    if(ItemMatcher.ItemMatcher(<contenttweaker:message_tablet>).matcher()(input)){
        if(isNull(input.tag))event.cancel();
        val player = world.getClosestPlayer(0.5+pos.x,0.5+pos.y,0.5+pos.z,32.0,false);
        if(!isNull(input.tag.translanted)){
            if(!isNull(player))player.sendRichTextStatusMessage(ITextComponent.fromTranslation((input.tag.translanted as string)),false);
            if(input.tag.translanted=="chat.alf_message_1"||input.tag.translanted=="chat.alf_message_4")event.output = <botania:lexicon>.withTag({"knowledge.minecraft": 1 as byte, "knowledge.alfheim": 1 as byte, "knowledge.relic": 1 as byte});
        }
        if(!isNull(input.tag.messages)){
            for i in input.tag.messages.asList(){
                player.sendRichTextStatusMessage(ITextComponent.fromString((ITextComponent.fromData([i] as IData).formattedText as IData).asMap().values[0]),false);
            }
        }
    }
    if(ItemMatcher.ItemMatcher(<minecraft:written_book>).matcher()(input)){
        if(isNull(input.tag)||isNull(input.tag.pages)){
            event.cancel();
            return;
        }
        var messages as IData = [];
        for i in input.tag.pages.asList(){
            messages += [(nativeTextComponent.Serializer.fromJsonLenient(i).wrapper.formattedText)];
        }
        event.output = <contenttweaker:message_tablet>.withTag({messages:messages});
    }
});