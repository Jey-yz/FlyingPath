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
    return Color.HSBtoRGB(((Botania.proxy.getWorldElapsedTicks() as float) * 2 % 360) / (360 as float), (0.4 as float), (1.0 as float))as int;
}) as IItemColor,Item.getByNameOrId("contenttweaker:gaia_essence"));