#version 330 core
#define NR_POINT_LIGHTS 8  

struct PointLight {    
    vec3 position;
    vec3 color;
    
    float constant;
    float linear;
    float quadratic;  

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};  
uniform int CntPointLights;
uniform PointLight pointLights[NR_POINT_LIGHTS];

out vec4 FragColor;

in vec3 color;
in vec2 TexCoords;

in vec3 Normal;
in vec3 FragPos;

uniform sampler2D tex0;
struct Material {
    sampler2D ambient;
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
}; 
uniform Material material;

uniform vec3 camPos;

vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - fragPos);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // attenuation
    float distance    = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + 
  			     light.quadratic * (distance * distance));    
    // combine results
    vec3 ambient  = light.ambient  * vec3(texture(material.diffuse, TexCoords));
    vec3 diffuse  = light.diffuse  * diff * vec3(texture(material.diffuse, TexCoords));
    vec3 specular = light.specular * spec * vec3(texture(material.specular, TexCoords));
    ambient  *= attenuation;
    diffuse  *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
} 

void main() 
{
    // float ambient = 0.35f;

    // vec3 normal = normalize(Normal);
    // vec3 lightDirection = normalize(lightPos - FragPos);
    // float diffuse = max(dot(normal, lightDirection), 0.0f);

    // float specularLight = 0.5f;
    // vec3 viewDir = normalize(camPos - FragPos);
    // vec3 reflectionDirection = reflect(-lightDirection, normal);
    // float specAmount = pow(max(dot(viewDir, reflectionDirection), 0.0f), 8);
    // float specular = specAmount * specularLight;

    // FragColor = texture(material.ambient, TexCoords) * lightColor * (diffuse + ambient + specular);

    // ===== Don't work
    vec3 norm = normalize(Normal);
    vec3 viewDir = normalize(camPos - FragPos);

    vec3 result = vec3(0.0);

    for(int i = 0; i < CntPointLights; i++) {
        result += CalcPointLight(pointLights[i], norm, FragPos, viewDir);
    }

    FragColor = vec4(result, 1.0);
}