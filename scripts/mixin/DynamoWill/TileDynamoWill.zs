#loader mixin
#priority 5
import scripts.mixin.DynamoWill.GuiDynamoWill;
import native.cofh.thermalexpansion.ThermalExpansion;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoEnervation;
import native.cofh.thermalexpansion.block.dynamo.TileDynamoBase;
import native.cofh.thermalexpansion.init.TEProps;
import native.cofh.core.util.helpers.ItemHelper;
import native.cofh.core.util.helpers.AugmentHelper;
import native.cofh.redstoneflux.impl.EnergyStorage;
import native.vazkii.botania.common.item.ModItems as BotItems;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.nbt.NBTTagCompound;
import native.net.minecraft.inventory.Container;
import native.net.minecraft.client.gui.inventory.GuiContainer;
import native.net.minecraft.entity.player.EntityPlayer;
import native.net.minecraft.entity.player.InventoryPlayer;
import native.net.minecraft.tileentity.TileEntity;
import native.net.minecraftforge.fml.common.registry.GameRegistry;
import native.java.util.Arrays;
import native.java.util.HashSet;
import native.java.lang.Object;
import mixin.CallbackInfo;
import mixin.CallbackInfoReturnable;

zenClass TileDynamoWill extends TileDynamoEnervation{
    static VALID_AUGMENTS as HashSet = HashSet();

    static initialize as function()void=function()as void{
		VALID_AUGMENTS.add(TEProps.DYNAMO_POWER);
        VALID_AUGMENTS.add(TEProps.DYNAMO_EFFICIENCY);
		VALID_AUGMENTS.add(TEProps.DYNAMO_COIL_DUCT);
		VALID_AUGMENTS.add(TEProps.DYNAMO_THROTTLE);
        GameRegistry.registerTileEntity(TileDynamoWill.class,"thermalexpansion:dynamo_will");
    };

    var lastFuel as ItemStack = ItemStack.EMPTY;

    zenConstructor() {
        super();
    }

    function getTileName() as string{
        return "tile.thermalexpansion.dynamo.will.name";
    }

    function getValidAugments()as HashSet{
        return VALID_AUGMENTS;
    }

    function canStart()as bool{
        return (getItemFuel(super.inventory[0])>0) as bool;
    }

    function processStart()as void{
        super.maxFuelRF = getItemFuel(super.inventory[0]) * super.energyMod / 100;
        super.fuelRF += super.maxFuelRF;
        lastFuel = super.inventory[0].copy();
        lastFuel.setCount(1);
        super.inventory[0] = ItemHelper.consumeItem(super.inventory[0]);
    }

    function getFuelEnergy(stack as ItemStack)as int{
        return getItemFuel(stack);
    }

    //isItemValidForSlot
    function func_94041_b(slot as int,item as ItemStack)as bool{
        return (getItemFuel(item)>0) as bool;
    }

    //readFromNBT
    function func_145839_a(nbt as NBTTagCompound)as void{
        super.readFromNBT(nbt);
        lastFuel = ItemStack(nbt.getCompoundTag("lastFuel"));
    }

    //writeToNBT
    function func_189515_b(nbt as NBTTagCompound)as NBTTagCompound{
        super.writeToNBT(nbt);
        nbt.setTag("lastFuel", lastFuel.writeToNBT(NBTTagCompound()));
        return nbt;
    }

    function getGuiClient(inventory as InventoryPlayer)as Object{
        return GuiDynamoWill.GuiDynamoWill(inventory, (this as TileEntity)) as Object;
    }
    
    function calcEnergy()as int{
        var power as int = getItemPower(lastFuel);
        if(power==0)return power;
        power = ((1.0+0.5*(super.level as double))*(power as double)) as int;
        var augment_power = 0;
        for i in 0 to super.getNumAugmentSlots(super.level)+1{
            if(i==0)continue;
            if(!(super.augments[-1+i].isEmpty()) && TEProps.DYNAMO_POWER == AugmentHelper.getAugmentIdentifier(super.augments[-1+i]))augment_power+=1;
        }
        power = power*(1+augment_power);
        var itemInSlot as ItemStack = ItemStack.EMPTY;
        if(super.inventory.length!=0){
            itemInSlot = super.inventory[0];
            if(itemInSlot.isItemEqual(lastFuel)){
                power = ((itemInSlot.getCount() as double)/(itemInSlot.getMaxStackSize() as double)*power) as int;
            }else{
                power = ((power as double)/3.0) as int;
            }
        }
        if(itemInSlot.isEmpty()){
            power = ((power as double)/8.0) as int;
        }
        (super.energyStorage as EnergyStorage).setMaxTransfer(power*2);
        if(((super.energyStorage.getEnergyStored()+power) > super.energyStorage.getMaxEnergyStored())&&super.augmentThrottle){
            return -super.energyStorage.getEnergyStored()+super.energyStorage.getMaxEnergyStored() as int;
        }else{
            return power;
        }
    }

    static ItemFuel as int[ItemStack] = {
        ItemStack(Item.getByNameOrId("botanicadds:gaia_shard"),1,0):80000,
        ItemStack(BotItems.manaResource,1,5):600000,
        ItemStack(BotItems.ancientWill,1,0):10000000,
        ItemStack(BotItems.ancientWill,1,1):2400000,
        ItemStack(BotItems.ancientWill,1,2):5000000,
        ItemStack(BotItems.ancientWill,1,3):20000000,
        ItemStack(BotItems.ancientWill,1,4):8000000,
        ItemStack(BotItems.ancientWill,1,5):2000000,
        ItemStack(Item.getByNameOrId("contenttweaker:gaia_essence"),1,0):400000
    };
        

    static ItemPower as int[ItemStack] = {
        ItemStack(Item.getByNameOrId("botanicadds:gaia_shard"),1,0):50,
        ItemStack(BotItems.manaResource,1,5):200,
        ItemStack(BotItems.ancientWill,1,0):10000,
        ItemStack(BotItems.ancientWill,1,1):80000,
        ItemStack(BotItems.ancientWill,1,2):50000,
        ItemStack(BotItems.ancientWill,1,3):5000,
        ItemStack(BotItems.ancientWill,1,4):40000,
        ItemStack(BotItems.ancientWill,1,5):100000,
        ItemStack(Item.getByNameOrId("contenttweaker:gaia_essence"),1,0):500
    };

    function getItemFuel(itemIn as ItemStack)as int{
        for item,fuel in ItemFuel{
            if(ItemStack.areItemsEqual(item,itemIn)){
                return fuel as int;
            }
        }
        return 0;
    }

    function getItemPower(itemIn as ItemStack)as int{
        for item,power in ItemPower{
            if(ItemStack.areItemsEqual(item,itemIn)){
                return power as int;
            }
        }
        return 0;
    }
}

#mixin Mixin
#{targets: "cofh.thermalexpansion.gui.container.dynamo.ContainerDynamoEnervation"}
zenClass MixinDynamoContainer{
    #mixin Overwrite
    function isItemValid(stack as ItemStack)as bool{
        if(this0.myTile instanceof TileDynamoWill){
            return this0.myTile.isItemValidForSlot(0,stack) as bool;
        }else{
            return this0.myTile.isItemValidForSlot(0,stack) as bool;
        }
    }
}
