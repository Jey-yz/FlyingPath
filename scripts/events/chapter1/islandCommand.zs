#reloadable
import scripts.libs.Data;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IWorld;
import crafttweaker.item.IItemStack;
import crafttweaker.data.IData;
import crafttweaker.util.Position3f;
import mods.zenutils.command.ZenCommand;
import mods.zenutils.command.ZenCommandTree;
import mods.zenutils.command.IGetTabCompletion;
import mods.zenutils.command.CommandUtils;
import mods.zenutils.NetworkHandler;
import native.net.minecraft.world.World;
import native.net.minecraft.command.CommandException;

static template as string[] = [
    "        00000000000        ",
    "      000000010000000      ",
    "     00001111111110000     ",
    "    0001112222222111000    ",
    "   000112222222222211000   ",
    "  00011223333333332211000  ",
    " 0001122333333333332211000 ",
    " 0011223334444444333221100 ",
    "000122333444444444333221000",
    "001123334445555544433321100",
    "001223344455555554443322100",
    "001223344555666555443322100",
    "001223344556666655443322100",
    "011223344556666655443322110",
    "001223344556666655443322100",
    "001223344555666555443322100",
    "001223344455555554443322100",
    "001123334445555544433321100",
    "000122333444444444333221000",
    " 0011223334444444333221100 ",
    " 0001122333333333332211000 ",
    "  00011223333333332211000  ",
    "   000112222222222211000   ",
    "    0001112222222111000    ",
    "     00001111111110000     ",
    "      000000010000000      ",
    "        00000000000        "];
static pattern1 as IItemStack[string] = {
    "0":<botania:quartztypedark>,
    "1":<botania:quartztypesunny>,
    "2":<botania:quartztypeelf>,
    "3":<botania:quartztypered>,
    "4":<botania:quartztypelavender>,
    "5":<botania:quartztypeblaze>,
    "6":<botania:quartztypemana>,
};
static pattern2 as IItemStack[string] = {
    "6":<botania:quartztypedark>,
    "5":<botania:quartztypesunny>,
    "4":<botania:quartztypeelf>,
    "3":<botania:quartztypered>,
    "2":<botania:quartztypelavender>,
    "1":<botania:quartztypeblaze>,
    "0":<botania:quartztypemana>
};

static mainIslandPos as IBlockPos = IBlockPos.create(8,3,8);
static distance as int = 1000;
val islandBuild = ZenCommand.create("build");
islandBuild.requiredPermissionLevel=1;
islandBuild.getCommandUsage = function(sender) {
    return "commands.island.build.usage";
};
islandBuild.tabCompletionGetters = [];
islandBuild.execute = function(command, server, sender, args) {
    if (args.length == 0) {
        CommandUtils.notifyWrongUsage("commands.island.build.usage");
    } else if (!isInt(args[0]) || (args[0] as int < 0)) {
        CommandUtils.notifyCommandFailure("commands.island.wrong2","\'"~args[0]~"\'");
    }
    val world = IWorld.getFromID(0);
    val id = args[0] as int;
    var ids = world.getCustomWorldData().dataGet("Islands")??([0] as IData);
    if(ids has id){
        CommandUtils.notifyCommandFailure("commands.island.wrong3","\'"~args[0]~"\'");
    }
    ids+=[id];
    world.setCustomWorldData(world.getCustomWorldData().dataSet(ids,"Islands"));
    createIsland(world,getPosByID(id));
};

val islandTP = ZenCommand.create("tp");
islandTP.requiredPermissionLevel=1;
islandTP.getCommandUsage = function(sender) {
    return "commands.island.tp.usage";
};
islandTP.tabCompletionGetters = [];
islandTP.execute = function(command, server, sender, args) {
    if (args.length == 0) {
        CommandUtils.notifyWrongUsage("commands.island.tp.usage");
    } else if (!isInt(args[0]) || (args[0] as int < 0)) {
        CommandUtils.notifyCommandFailure("commands.island.wrong2","\'"~args[0]~"\'");
    }
    val world = IWorld.getFromID(0);
    val id = args[0] as int;
    var ids = world.getCustomWorldData().dataGet("Islands")??([0] as IData);
    if(!(ids has id)){
        CommandUtils.notifyCommandFailure("commands.island.wrong4","\'"~args[0]~"\'");
    }
    var player = CommandUtils.getCommandSenderAsPlayer(sender);
    if(player.world.dimension!=0){
        CommandUtils.notifyCommandFailure("commands.island.wrong5","\'"~player.name~"\'");
    }
    val pos = player.world.native.getHeight(getPosByID(id).native);
    player.posX = 0.5+pos.getX();
    player.posZ = 0.5+pos.getZ();
    player.posY = (1.5+pos.getY()<4)?5.5:1.5+pos.getY();
    NetworkHandler.sendTo("IslandTeleport",player,function(b){
        b.writeData(Data.fromBlockPos(pos.wrapper));
    });
    // player.setPosition(pos.wrapper);
    // player.setFire(1);
};
NetworkHandler.registerServer2ClientMessage("IslandTeleport",function(p,b){
    var pos = Data.toBlockPos(b.readData());
    p.posX = 0.5+pos.x;
    p.posY = (1.5+pos.getY()<4)?5.5:1.5+pos.getY();
    p.posZ = 0.5+pos.z;
});

ZenCommandTree.create("island", islandBuild, islandTP).register();


function createIsland(world as IWorld, pos as IBlockPos)as void{
    for z in 0 to 27{
        for x in 0 to 27{
            val pos0 = pos.add(-x+13,0,-z+13);
            val pos1 = pos.add(-x+13,-1,-z+13);
            if(template[z][x]==" ")continue;
            val block1 = pattern1[template[z][x]].asBlock().definition.defaultState;
            val block2 = pattern2[template[z][x]].asBlock().definition.defaultState;
            if(block1.isReplaceable(world,pos0)){
                world.setBlockState(block1,pos0);
            }
            if(block2.isReplaceable(world,pos1)){
                world.setBlockState(block2,pos1);
            }
        }
    }
}
function getPosByID(id as int)as IBlockPos{
    var leng = 1;
    var pos as int[] = [0,0];
    if(id==0)return mainIslandPos;
    while (leng+2)*(leng+2)<(1+id){
        leng+=2;
    }
    val left = -(leng*leng)+id+1;
    leng+=2;
    if(left<=((1+leng)/2)){
        pos[1]=-(-1+leng)/2;
        pos[0]=-1+left;
    }else if(left-((1+leng)/2)<leng){
        pos[1]=left-leng;
        pos[0]=(-1+leng)/2;  
    }else if(left-((1+leng)/2)-(-1+leng)<leng){
        pos[0]=-(left+1)+leng*2;
        pos[1]=(-1+leng)/2;  
    }else if(left-((1+leng)/2)-(-1+leng)*2<leng){
        pos[0]=(-leng+1)/2; 
        pos[1]=leng*3-(left+2);
    }else{
        pos[0]=-((-1+leng)/2)+(left-((1+leng)/2)-(-1+leng)*3);
        pos[1]=(-leng+1)/2;
    }
    return mainIslandPos.add(pos[0]*distance,0,pos[1]*distance);
}

function isInt(inp as string)as bool{
    val whiteList = ["0","1","2","3","4","5","6","7","8","9","-"];
    if(inp[0]=="-"&&inp.length==1)return false;
    for i in 0 to inp.length{
        if(!(whiteList has inp[i]))return false;
        if(inp[i]=="-" && i!=0)return false;
    }
    return true;
}
