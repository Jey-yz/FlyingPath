#loader mixin
import native.net.minecraft.entity.player.EntityPlayer;

#mixin {targets: ["lumaceon.mods.clockworkphase.item.construct.clockwork.tool.ItemClockworkAxe","lumaceon.mods.clockworkphase.item.construct.clockwork.tool.ItemClockworkPickaxe","lumaceon.mods.clockworkphase.item.construct.clockwork.tool.ItemClockworkShovel"]}
zenClass MixinToolTimeSandExperienceLevel{
    #mixin Redirect{method:"func_179218_a",at:{value:"FIELD",target:"net/minecraft/entity/player/EntityPlayer.field_71068_ca",opcode:180}}
    function modifyPlayerExperienceLevel(player as EntityPlayer)as int{
        var explevel = 20;
        if(isNull(player))return explevel;
        val server = player.world.getMinecraftServer();
        if(isNull(server))return explevel;
        val players = server.getPlayerList().getPlayers();
        if(isNull(players)||players.length==0)return explevel;
        for p in players{
            if(p.experienceLevel>explevel)explevel = p.experienceLevel;
        }
        return explevel;
    }
}
#mixin {targets: "lumaceon.mods.clockworkphase.handler.EntityHandler"}
zenClass MixinSwordTimeSandExperienceLevel{
    #mixin Redirect{method:"onEntityAttacked",at:{value:"FIELD",target:"net/minecraft/entity/player/EntityPlayer.field_71068_ca",opcode:180}}
    function modifyPlayerExperienceLevel(player as EntityPlayer)as int{
        var explevel = 20;
        if(isNull(player))return explevel;
        val server = player.world.getMinecraftServer();
        if(isNull(server))return explevel;
        val players = server.getPlayerList().getPlayers();
        if(isNull(players)||players.length==0)return explevel;
        for p in players{
            if(p.experienceLevel>explevel)explevel = p.experienceLevel;
        }
        return explevel;
    }
}