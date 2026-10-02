#loader preinit
import native.lumaceon.mods.clockworkphase.item.component.generic.ItemBaseComponentGeneric;
import native.lumaceon.mods.clockworkphase.item.construct.abstracts.IDisassemble;
import native.lumaceon.mods.clockworkphase.util.DisassembleHelper;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.world.World;
import native.net.minecraftforge.event.RegistryEvent;

zenClass CustomClockworkComponent extends ItemBaseComponentGeneric,IDisassemble{
    val speed as int;
    val quality as int;
    val memory as int;
    val material as string;

    zenConstructor(speed as int, quality as int, memory as int, material as string){
        super();
        this.speed = speed;
        this.quality = quality;
        this.memory = memory;
        this.material = material;
    }

    function isComponentSpeedy(is as ItemStack)as bool{
        return (this.speed!=0);
    }

    function isComponentQuality(is as ItemStack)as bool{
        return (this.quality!=0);
    }

    function isComponentMemory(is as ItemStack)as bool{
        return (this.memory!=0);
    }

    function getGearSpeed(is as ItemStack)as int{
        return speed;
    }

    function getGearQuality(is as ItemStack)as int{
        return quality;
    }

    function getMemoryValue(is as ItemStack)as int{
        return memory;
    }

    function disassemble(world as World, x as double, y as double, z as double, is as ItemStack)as void{
        if(!world.isRemote){
            DisassembleHelper.disassembleMetalGear(world, x, y, z, is, "ingot"~this.material);
        }
    }
}

static gears as Item[] = [];
function addGear(speed as int, quality as int, memory as int, material as string)as void{
    gears += CustomClockworkComponent(speed, quality, memory, material).setTranslationKey("contenttweaker.gear_"~material.toLowerCase()).setRegistryName("contenttweaker","gear_"~material.toLowerCase()) as Item;
}
//We dont have ingotPaper, but who cares?
static picture as Item = CustomClockworkComponent(0, 0, 32767, "Paper").setTranslationKey("contenttweaker.memory_painting").setRegistryName("contenttweaker","memory_painting") as Item;

addGear(75,75,-15,"Enderium");
addGear(45,35,25,"Lumium");
addGear(60,20,5,"Dawnstone");

events.register(function(event as RegistryEvent.Register){
    val registryName=event.name.toString();
    if(registryName == "minecraft:items"){
        for gear in gears{
            event.registry.register(gear);
        }
        event.registry.register(picture);
    }
});
