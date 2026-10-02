#loader coloritem
#sideonly client
import native.net.minecraft.client.Minecraft;
import native.net.minecraft.client.renderer.color.IItemColor;
import native.net.minecraft.client.renderer.color.ItemColors;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.vazkii.botania.common.Botania;
import native.java.awt.Color;

Minecraft.getMinecraft().getItemColors().registerItemColorHandler((function(item as ItemStack, i as int){
    var brightness as float = 0.6 as float;
    if(item.hasTagCompound() && !isNull(item.getTagCompound().getInteger("process")))brightness += (item.getTagCompound().getInteger("process")as float)/250 as float;
    return Color.HSBtoRGB((((-1.0 as float)*((Botania.proxy.getWorldElapsedTicks() as float) * 2 % 360))+360) / (360 as float), (0.25 as float), brightness as float)as int;
}) as IItemColor,Item.getByNameOrId("contenttweaker:gaia_ingot"));