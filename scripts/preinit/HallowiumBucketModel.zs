#loader preinit
#priority 100
#sideonly client
import native.net.minecraft.client.Minecraft;
import native.net.minecraft.client.model.ModelBiped;
import native.net.minecraft.client.model.ModelPlayer;
import native.net.minecraft.client.renderer.BufferBuilder;
import native.net.minecraft.client.renderer.GlStateManager;
import native.net.minecraft.client.renderer.Tessellator;
import native.net.minecraft.client.renderer.block.model.BakedQuad;
import native.net.minecraft.client.renderer.block.model.IBakedModel;
import native.net.minecraft.client.renderer.block.model.ItemCameraTransforms;
import native.net.minecraft.client.renderer.texture.TextureMap;
import native.net.minecraft.client.renderer.vertex.DefaultVertexFormats;
import native.net.minecraft.client.renderer.entity.layers.LayerRenderer;
import native.net.minecraft.entity.Entity;
import native.net.minecraft.entity.EntityLivingBase;
import native.net.minecraft.entity.player.EntityPlayer;
import native.net.minecraft.inventory.EntityEquipmentSlot;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraftforge.client.event.RenderPlayerEvent;
import native.net.minecraftforge.client.ForgeHooksClient;
import native.net.minecraftforge.client.model.pipeline.LightUtil;
import native.java.lang.Math;
import native.org.lwjgl.opengl.GL11;

zenClass HallowiumBucketModel extends ModelBiped{
    zenConstructor(){
        //EmptyModel
        super();
        this.bipedHead.showModel = false;
        this.bipedHeadwear.showModel = false;
        this.bipedBody.showModel = false;
        this.bipedRightArm.showModel = false;
        this.bipedLeftArm.showModel = false;
        this.bipedRightLeg.showModel = false;
        this.bipedLeftLeg.showModel = false;
    }

    //render
    function func_78088_a(entity as Entity, var1 as float, var2 as float, var3 as float, var4 as float, var5 as float, var6 as float)as void{
        //Do nothing
    }
}

zenClass HallowiumBucketLayer extends LayerRenderer{
    val playerModel as ModelPlayer;

    zenConstructor(playerModel as ModelPlayer){
        this.playerModel = playerModel;
    }

    //render
    function func_177141_a(entity as EntityLivingBase, limbSwing as float, limbSwingAmount as float, partialTicks as float, ageInTicks as float, netHeadYaw as float, headPitch as float, scale as float)as void{
        val bucket as ItemStack = entity.getItemStackFromSlot(EntityEquipmentSlot.HEAD);
        if(bucket.isEmpty())return;
        if(!ItemStack.areItemsEqual(bucket,ItemStack(Item.getByNameOrId("contenttweaker:hallowium_bucket"))))return;
        GlStateManager.pushMatrix();
        this.playerModel.bipedHead.postRender(scale);
        if(entity.isSneaking()){
            GlStateManager.translate(-0.4f, -1.4f, -0.1f);
        }else{
            GlStateManager.translate(-0.4f, -1.6f, -0.1f);
        }
        val angle = 0.05f*(partialTicks+entity.ticksExisted);
        val offsetX = 1.0f * Math.cos(angle);
        val offsetY = 0.05f * Math.sin(angle);
        val offsetZ = 1.0f * Math.sin(angle);
        GlStateManager.scale(0.8f, 0.8f, 0.8f);
        GlStateManager.rotate(180.0f, 0.0f, 1.0f, 0.0f);
        renderBucket(bucket,1.0f,0.0f,0.0f,0.0f);
        renderBucket(bucket,0.3f,offsetX,offsetY,offsetZ);
        renderBucket(bucket,0.3f,-offsetX,-offsetY,-offsetZ);

        GlStateManager.popMatrix();
    }

    function renderBucket(bucket as ItemStack, alpha as float, dx as float, dy as float, dz as float)as void{
        GlStateManager.pushMatrix();
        GlStateManager.translate(dx, dy, dz);
        var model as IBakedModel = Minecraft.getMinecraft().getRenderItem().getItemModelWithOverrides(bucket, null, null);
        model = ForgeHooksClient.handleCameraTransforms(model, ItemCameraTransforms.TransformType.HEAD, false);
        Minecraft.getMinecraft().getTextureManager().bindTexture(TextureMap.LOCATION_BLOCKS_TEXTURE);
        GlStateManager.enableBlend();
        GlStateManager.blendFunc(GL11.GL_SRC_ALPHA, GL11.GL_ONE_MINUS_SRC_ALPHA);
        GlStateManager.color(1.0f, 1.0f, 1.0f, alpha);
        val tessellator as Tessellator = Tessellator.getInstance();
        val buffer as BufferBuilder = tessellator.getBuffer();
        buffer.begin(GL11.GL_QUADS, DefaultVertexFormats.ITEM);
        for quad in model.getQuads(null, null, 0){
            LightUtil.renderQuadColor(buffer, quad as BakedQuad, ((((alpha*255)as int)*16777216)|0x00FFFFFF));
        }
        tessellator.draw();
        GlStateManager.color(1.0f, 1.0f, 1.0f, 1.0f);
        GlStateManager.disableBlend();
        GlStateManager.popMatrix();
    }

    //shouldCombineTextures
    function func_177142_b()as bool{
        return false;
    }
}

static flag as bool = false;
function setFlag(f as bool)as void{
    flag = f;
}
events.register(function(event as RenderPlayerEvent.Pre){
    if(!flag){
        event.getRenderer().addLayer(HallowiumBucketLayer(event.getRenderer().getMainModel() as ModelPlayer));
        setFlag(true);
    }
});