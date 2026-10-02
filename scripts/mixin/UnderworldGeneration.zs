#loader mixin
import native.net.minecraft.init.Items;
import native.net.minecraft.block.Block;
import native.net.minecraft.block.BlockGrass;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.block.properties.PropertyBool;
import native.net.minecraft.enchantment.Enchantment;
import native.net.minecraft.enchantment.EnchantmentHelper;
import native.net.minecraft.world.IBlockAccess;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.util.EnumFacing;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraftforge.common.IPlantable;
import native.sblectric.lightningcraft.init.LCBlocks;
import native.sblectric.lightningcraft.init.LCItems;
import native.sblectric.lightningcraft.init.LCEnchantments;
import native.sblectric.lightningcraft.ref.Material;
import native.sblectric.lightningcraft.util.WeightedRandomChestContent;
import native.sblectric.lightningcraft.worldgen.structure.LootChestGroup;
import native.vazkii.botania.common.item.ModItems as BotItems;

#mixin Mixin
#{targets: "sblectric.lightningcraft.dimensions.ChunkProviderUnderworld"}
zenClass MixinUnderworldDimension{
    #mixin ModifyConstant{method: "func_185931_b", constant: {intValue: 0, ordinal: 7}}
    function noOres(value as int)as int{
        return 5 as int;//There are only 4 types of ores
    }
    #mixin Redirect{method: "replaceBiomeBlocks", at: {value: "INVOKE", target: "net/minecraft/block/Block.func_176223_P()Lnet/minecraft/block/state/IBlockState;",ordinal=1}}
    function noStones(block as Block)as IBlockState{
        return LCBlocks.corruptStone.getDefaultState();
    }
    #mixin Redirect{method: "replaceBiomeBlocks", at: {value: "INVOKE", target: "net/minecraft/block/Block.func_176223_P()Lnet/minecraft/block/state/IBlockState;",ordinal=2}}
    function noDirts(block as Block)as IBlockState{
        return LCBlocks.corruptStone.getDefaultState();
    }
    #mixin Redirect{method: "replaceBiomeBlocks", at: {value: "INVOKE", target: "net/minecraft/block/BlockGrass.func_176223_P()Lnet/minecraft/block/state/IBlockState;"}}
    function noGrasses(block as BlockGrass)as IBlockState{
        return LCBlocks.underSand.getDefaultState();
    }
}

#mixin Mixin
#{targets: "sblectric.lightningcraft.worldgen.structure.underworld.UnderworldWaterTemple"}
zenClass MixinWaterTempleStructure{
    #mixin Redirect{method: "func_74875_a", at: {value: "FIELD", target: "sblectric/lightningcraft/worldgen/structure/underworld/UnderworldWaterTemple.lapisBlock", opcode:178}}
    function replaceLapisBlock()as Block{
        return Block.getBlockFromName("incorporeal:corporea_deco");
    }
    #mixin Redirect{method: "<init>(Ljava/util/Random;II)V", at: {value: "NEW", target: "sblectric/lightningcraft/worldgen/structure/LootChestGroup"}}
    function ModifyChestLoots(n as int, min as int, max as int, contents as WeightedRandomChestContent[])as LootChestGroup{
        val newContents = [WeightedRandomChestContent(BotItems.manaResource, 5, 12, 30, 18),WeightedRandomChestContent(Item.getByNameOrId("clockworkphase:brass_ingot"), 0, 2, 4, 20),
                WeightedRandomChestContent(Item.getByNameOrId("thermalfoundation:material"), 230, 32, 60, 28),WeightedRandomChestContent(Item.getByNameOrId("prodigytech:inferno_fuel"), 0, 3, 5, 20),
                WeightedRandomChestContent(BotItems.blackLotus, 0, 18, 25, 20),WeightedRandomChestContent(LCItems.soulSword, 0, 1, 1, 1),
                WeightedRandomChestContent(LCItems.zombieSword, 0, 1, 1, 1),WeightedRandomChestContent(LCItems.featherSword, 0, 1, 1, 1),
                WeightedRandomChestContent(LCItems.enderSword, 0, 1, 1, 1),WeightedRandomChestContent(LCItems.elecSword, 0, 1, 1, 1)] as WeightedRandomChestContent[];
        return LootChestGroup(n,min,max,newContents);
    }
}
#mixin Mixin
#{targets: "sblectric.lightningcraft.worldgen.structure.underworld.UnderworldTower"}
zenClass MixinUnderworldTowerStructure{
    #mixin Redirect{method: "<init>(Ljava/util/Random;II)V", at: {value: "NEW", target: "sblectric/lightningcraft/worldgen/structure/LootChestGroup"}}
    function ModifyChestLoots(n as int, min as int, max as int, contents as WeightedRandomChestContent[])as LootChestGroup{
        var book1 = ItemStack(Items.ENCHANTED_BOOK);
        var book2 = ItemStack(Items.ENCHANTED_BOOK);
        EnchantmentHelper.setEnchantments({LCEnchantments.handOfThor:1}as int[Enchantment], book1);
        EnchantmentHelper.setEnchantments({LCEnchantments.elecAura:1}as int[Enchantment], book2);
        var contentBook1 = WeightedRandomChestContent(null, 0, 1, 2, 2);
        contentBook1.theItemId = book1;
        var contentBook2 = WeightedRandomChestContent(null, 0, 1, 2, 2);
        contentBook2.theItemId = book2;
        val newContents = [WeightedRandomChestContent(LCItems.material, Material.DEMON_BLOOD, 2, 6, 8),WeightedRandomChestContent(BotItems.manaResource, 14, 2, 5, 15),
			WeightedRandomChestContent(Items.FIRE_CHARGE, 0, 8, 18, 15),WeightedRandomChestContent(Item.getByNameOrId("projecte:matter_block"), 0, 20, 32, 8),
            WeightedRandomChestContent(BotItems.blackLotus, 1, 2, 3, 5), WeightedRandomChestContent(Item.getByNameOrId("contenttweaker:gaia_essence"), 0, 6, 10, 10),
            WeightedRandomChestContent(BotItems.manaResource, 15, 2, 5, 12),WeightedRandomChestContent(Item.getByNameOrId("botania:livingwood"), 0, 8, 12, 18),
			WeightedRandomChestContent(LCItems.elecBoots, 0, 1, 1, 1), WeightedRandomChestContent(LCItems.elecLegs, 0, 1, 1, 1), 
			WeightedRandomChestContent(LCItems.elecHelm, 0, 1, 1, 1), WeightedRandomChestContent(LCItems.elecChest, 0, 1, 1, 1),
			WeightedRandomChestContent(LCItems.elecSword, 0, 1, 1, 1),contentBook1, contentBook2] as WeightedRandomChestContent[];
        return LootChestGroup(n,min,max,newContents);
    }
}
#mixin Mixin
#{targets: "sblectric.lightningcraft.worldgen.structure.underworld.UnderworldRampart"}
zenClass MixinUnderworldRampartStructure{
    #mixin Redirect{method: "func_74875_a", at: {value: "FIELD", target: "sblectric/lightningcraft/worldgen/structure/underworld/UnderworldRampart.accentBlock", opcode:178}}
    function replaceObsidianBlock()as Block{
        return Block.getBlockFromName("minecraft:coal_block");
    }

    #mixin Redirect{method: "<init>(Ljava/util/Random;II)V", at: {value: "NEW", target: "sblectric/lightningcraft/worldgen/structure/LootChestGroup"}}
    function ModifyChestLoots(n as int, min as int, max as int, contents as WeightedRandomChestContent[])as LootChestGroup{
        val newContents = [WeightedRandomChestContent(Items.GOLDEN_APPLE, 0, 1, 3, 5),WeightedRandomChestContent(Item.getByNameOrId("clockworkphase:nugget_temporal"), 0, 3, 10, 10),
            WeightedRandomChestContent(Item.getByNameOrId("contenttweaker:frame_elven"), 0, 1, 3, 10), WeightedRandomChestContent(Item.getByNameOrId("botania:ancientwill"), 0, 1, 1, 4),
            WeightedRandomChestContent(Item.getByNameOrId("botania:ancientwill"), 1, 1, 1, 4),WeightedRandomChestContent(Item.getByNameOrId("botania:ancientwill"), 2, 1, 1, 4),
            WeightedRandomChestContent(Item.getByNameOrId("botania:ancientwill"), 3, 1, 1, 4),WeightedRandomChestContent(Item.getByNameOrId("botania:ancientwill"), 4, 1, 1, 4),
            WeightedRandomChestContent(Item.getByNameOrId("botania:ancientwill"), 5, 1, 1, 4),WeightedRandomChestContent(LCItems.golfClub, 0, 1, 1, 8),WeightedRandomChestContent(Item.getByNameOrId("botania:livingwood"), 5, 3, 7, 12),
            WeightedRandomChestContent(LCItems.skySword, 0, 1, 1, 1), WeightedRandomChestContent(LCItems.skyAxe, 0, 1, 1, 1),
            WeightedRandomChestContent(LCItems.elecSword, 0, 1, 1, 1)] as WeightedRandomChestContent[];
        return LootChestGroup(n,min,max,newContents);
    }

    #mixin Redirect{method: "<init>(Ljava/util/Random;II)V", at: {value: "INVOKE", target: "sblectric/lightningcraft/worldgen/structure/LootChestGroup.setChestContents(I[Lsblectric/lightningcraft/util/WeightedRandomChestContent;)V"}}
    function AddForces(chests as LootChestGroup, n as int, contents as WeightedRandomChestContent[])as void{
        val newContents = [WeightedRandomChestContent(LCItems.material, 11, 5, 15, 97),
            WeightedRandomChestContent(Item.getByNameOrId("contenttweaker:force_of_murder"), 0, 1, 1, 1), 
            WeightedRandomChestContent(Item.getByNameOrId("contenttweaker:force_of_aid"), 0, 1, 1, 1), 
            WeightedRandomChestContent(Item.getByNameOrId("contenttweaker:force_of_life"), 0, 1, 1, 1)
        ]as WeightedRandomChestContent[];
        chests.setChestContents(2,newContents);
    }
    #mixin Redirect{method: "<init>(Ljava/util/Random;II)V", at: {value: "INVOKE", target: "sblectric/lightningcraft/worldgen/structure/LootChestGroup.setStackMinMax(III)V"}}
    function ModifyStacks(chests as LootChestGroup, n as int, min as int, max as int)as void{
        chests.setStackMinMax(2,2,2);
    }
}

#mixin Mixin
#{targets: "sblectric.lightningcraft.worldgen.WorldGenUnderworldTrees"}
zenClass MixinUnderworldTrees{
    #mixin Redirect{method: "func_180709_b", at: {value: "INVOKE", target: "net/minecraft/block/Block.canSustainPlant(Lnet/minecraft/block/state/IBlockState;Lnet/minecraft/world/IBlockAccess;Lnet/minecraft/util/math/BlockPos;Lnet/minecraft/util/EnumFacing;Lnet/minecraftforge/common/IPlantable;)Z"}}
    function plantOnSand(block as Block, state as IBlockState, world as IBlockAccess, pos as BlockPos, facing as EnumFacing, plant as IPlantable)as bool{
        return (block == LCBlocks.underSand)as bool;
    }

    #mixin Redirect{method: "func_180709_b", at: {value: "FIELD", target: "sblectric/lightningcraft/worldgen/WorldGenUnderworldTrees.metaLeaves",opcode:180}}
    function newLeaves(trees as native.sblectric.lightningcraft.worldgen.WorldGenUnderworldTrees)as IBlockState{
        return Block.getBlockFromName("lightningcraft:wood_leaves").getDefaultState()
                .withProperty(PropertyBool.create("decayable"), true)
				.withProperty(PropertyBool.create("check_decay"), true);
    }
}
