#reloadable
import scripts.libs.Misc;
import scripts.libs.Data;
import scripts.libs.Craft;
import scripts.libs.ItemMatcher;
import scripts.libs.BlockMatcher;
import scripts.events.onBlockDrops;
import scripts.events.onItemUse;
import scripts.jei.multiBlockJEI;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import crafttweaker.item.WeightedItemStack;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.player.IPlayer;
import crafttweaker.util.Math;
import crafttweaker.text.ITextComponent;
import mods.zenutils.NetworkHandler;
import mods.randomtweaker.botania.IBotaniaFXHelper;

static template as string = "  b  ; BbB ;mmrll; BeB ;  e  ";
static pattern as IItemStack[string]= {
    "b":<botania:quartztypeblaze:1>,"B":<minecraft:beacon>,
    "m":<botania:quartztypemana:1>,"r":<botania:quartztypered:1>,
    "l":<botania:quartztypelavender:1>,"e":<botania:quartztypeelf:1>
};

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<botania:quartztypered:1>).matcher(),
    function(world as IWorld, pos as IBlockPos, hammer as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        if(checkStructure(world,pos,player)){
            for i in 0 to 5{
                for j in 0 to 5{
                    if(template.split(";")[i][j]!=" ")world.destroyBlock(pos.add(-2+j,0,-2+i),false);
                    if(i==2&&j==2){
                        world.setBlockState(<blockstate:botania:manaflame>,pos.add(-2+i,-1,-2+j));
                    }else{
                        world.destroyBlock(pos.add(-2+i,-1,-2+j),false);
                    }
                }
            }
            world.catenation().then(function(w,c){
                world.setBlockState(<blockstate:collision:collider_lv1>,pos);
            }).start();
        }
        return true;
    }
);

function checkStructure(world as IWorld, pos as IBlockPos, player as IPlayer)as bool{
    var x = -2;
    var z = -2;
    if(!BlockMatcher.BlockMatcher(<thermalfoundation:storage_alloy:6>).matcher()(world,pos.add(0,-1,0))){
        // NetworkHandler.sendToAllAround("MissingBlockPosition",pos.x,pos.y,pos.z,20,world.getDimension(),function(b){
        //     b.writeData(Data.fromBlockPos(pos.add(0,-1,0)));
        // });
        // player.sendChat(ITextComponent.fromTranslation("chat.miss_block_at", pos.add(0,-1,0).asString(), <thermalfoundation:storage_alloy:6>.asBlock().displayName).unformattedText);
        Misc.missBlock(player, pos.add(0,-1,0), <thermalfoundation:storage_alloy:6>.asBlock().displayName);
        return false;
    }
    for a in 0 to template.length{
        val i = template[a];
        if((x!=0 && z!=0 && x<3 && z<3) && !BlockMatcher.BlockMatcher(<minecraft:end_stone>).matcher()(world,pos.add(x,-1,z))){
            // NetworkHandler.sendToAllAround("MissingBlockPosition",pos.x,pos.y,pos.z,20,world.getDimension(),function(b){
            //     b.writeData(Data.fromBlockPos(pos.add(x,-1,z)));
            // });
            // player.sendChat(ITextComponent.fromTranslation("chat.miss_block_at", pos.add(x,-1,z).asString(), <minecraft:end_stone>.displayName).unformattedText);
            Misc.missBlock(player, pos.add(x,-1,z), <minecraft:end_stone>.displayName);
            return false;
        }
        if(i==" "){
            x+=1;
            continue;
        }
        if(i==";"){
            z+=1;
            x=-2;
            continue;
        }
        if(!BlockMatcher.BlockMatcher(pattern[i]).matcher()(world,IBlockPos.create(pos.x+x,pos.y,pos.z+z))){
            // NetworkHandler.sendToAllAround("MissingBlockPosition",pos.x,pos.y,pos.z,20,world.getDimension(),function(b){
            //     b.writeData(Data.fromBlockPos(pos.add(x,0,z)));
            // });
            // player.sendChat(ITextComponent.fromTranslation("chat.miss_block_at", (pos.x+x) as string~" "~(pos.y)~" "~(pos.z+z) as string, pattern[i].displayName).unformattedText);
            Misc.missBlock(player, pos.add(x,0,z), pattern[i].displayName);
            return false;
        }
        x+=1;
    }
    return true;
}

var pattern1 = pattern;
pattern1[" "] = <contenttweaker:gunmu>;
val layer0 as IIngredient[][] = Craft.map("eeeee;eeeee;eelee;eeeee;eeeee",{"e":<minecraft:end_stone>,"l":<thermalfoundation:storage_alloy:6>});
val layer1 as IIngredient[][] = Craft.map(template,pattern1);
multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize(layer0),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(layer1),3,0,3)
        ])
    ,
    [<collision:collider_lv1>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString()]),
     <botania:lens:17>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,-1,0).asString()])
    ]
);

static templateTier2 as IIngredient[string]={
    "N":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=south"),
    "W":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=east"),
    "E":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=west"),
    "S":Craft.addLore(<embers:stairs_caminite_brick>,"shape=straight,half=top,facing=north"),
    "C":<embers:block_caminite_brick>,"F":<botania:lens:17>," ":<contenttweaker:gunmu>,"G":<minecraft:glowstone>,
    "R":<botania:shimmerrock>,"M":<collision:collider_lv1>,"P":<projecte:fuel_block>,
    "1":<botania:blazeblock>,"2":<minecraft:beacon>,"3":<embers:mech_core>,"4":<contenttweaker:block_pulse>,
    "T":<embers:ember_pipe>
};
static Layer0 as IIngredient[][] = Craft.map("   N   ; CCCCC ; CCCCC ;WCCFCCE; CCCCC ; CCCCC ;   S   ",templateTier2);
static Layer1 as IIngredient[][] = Craft.map("   G   ; RR1RR ; RP1PR ;G22M33G; RP4PR ; RR4RR ;   G   ",templateTier2);
static Layer2 as IIngredient[][] = Craft.map("   T   ;  TTT  ; TT TT ;TT   TT; TT TT ;  TTT  ;   T   ",templateTier2);

onItemUse.onItemRightClickBlock(ItemMatcher.ItemMatcher(<embers:tinker_hammer>).matcher(),
    BlockMatcher.BlockMatcher(<collision:collider_lv1>).matcher(),
    function(world as IWorld, pos as IBlockPos, ingot as IItemStack, player as IPlayer, hand as string)as bool{
        if(!player.isSneaking)return false;
        if(checkStructureTier2(world,pos,player)){
            for i in 0 to 7{
                for j in 0 to 7{
                    if(!<contenttweaker:gunmu>.matches(Layer0[i][j].items[0]))world.destroyBlock(pos.add(-3+j,-1,-3+i),false);
                    if(!<contenttweaker:gunmu>.matches(Layer1[i][j].items[0]))world.destroyBlock(pos.add(-3+j,0,-3+i),false);
                    if(!<contenttweaker:gunmu>.matches(Layer2[i][j].items[0]))world.destroyBlock(pos.add(-3+j,1,-3+i),false);
                }
            }
            world.setBlockState(<blockstate:collision:collider_lv2>,pos);
        }
        return true;
    }
);

function checkStructureTier2(world as IWorld, pos as IBlockPos, player as IPlayer)as bool{
    for y in -1 to 2{
        for z in -3 to 4{
            for x in -3 to 4{
                if(y==-1){
                    val stairs as string[int[]] = {[0,-3]:"south",[-3,0]:"east",[3,0]:"west",[0,3]:"north"};
                    if(x==0 && z==0 && !BlockMatcher.BlockMatcher("botania:manaflame").matcher()(world,pos.add(0,-1,0))){
                        Misc.missBlock(player, pos.add(0,-1,0), game.localize("tile.botania:manaFlame.name"));
                        return false;
                    }
                    else if(Math.abs(x)<3 && Math.abs(z)<3 && (x!=0 || z!=0) && !BlockMatcher.BlockMatcher(<embers:block_caminite_brick>).matcher()(world,pos.add(x,-1,z))){
                        Misc.missBlock(player, pos.add(x,-1,z), <embers:block_caminite_brick>.displayName);
                        return false;
                    }else if((Math.abs(x)==3||Math.abs(z)==3) && x*z==0){
                        for p, facing in stairs{
                            if(p[0]==x&&p[1]==z){
                                if(!BlockMatcher.BlockMatcher(<blockstate:embers:stairs_caminite_brick:shape=straight,half=top,facing=${facing}>).matcher()(world,pos.add(x,-1,z))){
                                    Misc.missBlock(player,pos.add(x,-1,z),<embers:stairs_caminite_brick>.displayName+"(shape=straight,half=top,facing="+facing+")");
                                    return false;
                                }
                            }
                        }
                    }
                }
                if(y==0){
                    val item = Layer1[z+3][x+3].items[0];
                    if(<contenttweaker:gunmu>.matches(item))continue;
                    if(!BlockMatcher.BlockMatcher(item).matcher()(world,pos.add(x,0,z))){
                        Misc.missBlock(player,pos.add(x,0,z),item.displayName);
                        return false;
                    }
                }
                if(y==1){
                    val item = Layer2[z+3][x+3].items[0];
                    if(<contenttweaker:gunmu>.matches(item))continue;
                    if(!BlockMatcher.BlockMatcher(item).matcher()(world,pos.add(x,1,z))){
                        Misc.missBlock(player,pos.add(x,1,z),item.displayName);
                        return false;
                    }
                }
            }
        }
    }
    return true;
}

multiBlockJEI.addRecipe(
    multiBlockJEI.layers(
        [multiBlockJEI.addPosTips(multiBlockJEI.resize(Layer0),3,-1,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(Layer1),3,0,3),
         multiBlockJEI.addPosTips(multiBlockJEI.resize(Layer2),3,1,3)
        ])
    ,
    [<collision:collider_lv2>.withLore([game.localize("jei.tooltip.multi_block.pos")~IBlockPos.create(0,0,0).asString()]),]
);