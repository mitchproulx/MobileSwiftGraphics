//
//  Shaders.metal
//  GraphicsProject
//
// Mitchell Proulx
// 7660132
//

/* 
 - You can include multiple shaders in a single Metal file.
 - You can also split your shaders across multiple Metal files
 - Shaders are precompiled
*/

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut{
    float4 position [[position]];  //1
    float4 color;
};

struct Uniforms{
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut shade_vertex(
                              const device VertexIn* vertex_array [[ buffer(0) ]],
                              const device Uniforms&  uniforms    [[ buffer(1) ]],           //1
                              unsigned int vid [[ vertex_id ]]) {
    
    float4x4 mv_Matrix = uniforms.modelMatrix;                     //2
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    
    VertexIn VertexIn = vertex_array[vid];
    
    VertexOut VertexOut;
    VertexOut.position = proj_Matrix * mv_Matrix * float4(VertexIn.position,1);
    VertexOut.color = VertexIn.color;
    
    return VertexOut;
}

fragment half4 shade_fragment(VertexOut interpolated [[stage_in]]) {  //1
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]); //2
}
