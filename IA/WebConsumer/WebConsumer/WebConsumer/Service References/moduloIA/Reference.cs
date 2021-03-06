﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.17929
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebConsumer.moduloIA {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="moduloIA.IModuloIa")]
    public interface IModuloIa {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/tamanhoRede", ReplyAction="http://tempuri.org/IModuloIa/tamanhoRedeResponse")]
        string tamanhoRede(int nivel, string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/tamanhoRede", ReplyAction="http://tempuri.org/IModuloIa/tamanhoRedeResponse")]
        System.Threading.Tasks.Task<string> tamanhoRedeAsync(int nivel, string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/redeNivel", ReplyAction="http://tempuri.org/IModuloIa/redeNivelResponse")]
        string redeNivel(int nivel, string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/redeNivel", ReplyAction="http://tempuri.org/IModuloIa/redeNivelResponse")]
        System.Threading.Tasks.Task<string> redeNivelAsync(int nivel, string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/amigosTag", ReplyAction="http://tempuri.org/IModuloIa/amigosTagResponse")]
        string amigosTag(string user, string tags);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/amigosTag", ReplyAction="http://tempuri.org/IModuloIa/amigosTagResponse")]
        System.Threading.Tasks.Task<string> amigosTagAsync(string user, string tags);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/sugerirAmigos", ReplyAction="http://tempuri.org/IModuloIa/sugerirAmigosResponse")]
        string sugerirAmigos(string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/sugerirAmigos", ReplyAction="http://tempuri.org/IModuloIa/sugerirAmigosResponse")]
        System.Threading.Tasks.Task<string> sugerirAmigosAsync(string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/maven", ReplyAction="http://tempuri.org/IModuloIa/mavenResponse")]
        string maven(string tag);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/maven", ReplyAction="http://tempuri.org/IModuloIa/mavenResponse")]
        System.Threading.Tasks.Task<string> mavenAsync(string tag);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/amigosComuns", ReplyAction="http://tempuri.org/IModuloIa/amigosComunsResponse")]
        string amigosComuns(string user1, string user2);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/amigosComuns", ReplyAction="http://tempuri.org/IModuloIa/amigosComunsResponse")]
        System.Threading.Tasks.Task<string> amigosComunsAsync(string user1, string user2);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/caminhoForte", ReplyAction="http://tempuri.org/IModuloIa/caminhoForteResponse")]
        string caminhoForte(string userOrigem, string userDestino);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/caminhoForte", ReplyAction="http://tempuri.org/IModuloIa/caminhoForteResponse")]
        System.Threading.Tasks.Task<string> caminhoForteAsync(string userOrigem, string userDestino);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/caminhoCurto", ReplyAction="http://tempuri.org/IModuloIa/caminhoCurtoResponse")]
        string caminhoCurto(string userOrigem, string userDestino);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/caminhoCurto", ReplyAction="http://tempuri.org/IModuloIa/caminhoCurtoResponse")]
        System.Threading.Tasks.Task<string> caminhoCurtoAsync(string userOrigem, string userDestino);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/grauMedioSeparacao", ReplyAction="http://tempuri.org/IModuloIa/grauMedioSeparacaoResponse")]
        string grauMedioSeparacao();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/grauMedioSeparacao", ReplyAction="http://tempuri.org/IModuloIa/grauMedioSeparacaoResponse")]
        System.Threading.Tasks.Task<string> grauMedioSeparacaoAsync();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/grafoNivel3", ReplyAction="http://tempuri.org/IModuloIa/grafoNivel3Response")]
        string grafoNivel3(string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/grafoNivel3", ReplyAction="http://tempuri.org/IModuloIa/grafoNivel3Response")]
        System.Threading.Tasks.Task<string> grafoNivel3Async(string user);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/traduzir", ReplyAction="http://tempuri.org/IModuloIa/traduzirResponse")]
        string traduzir(string orig);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/traduzir", ReplyAction="http://tempuri.org/IModuloIa/traduzirResponse")]
        System.Threading.Tasks.Task<string> traduzirAsync(string orig);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/debug", ReplyAction="http://tempuri.org/IModuloIa/debugResponse")]
        string debug();
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IModuloIa/debug", ReplyAction="http://tempuri.org/IModuloIa/debugResponse")]
        System.Threading.Tasks.Task<string> debugAsync();
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IModuloIaChannel : WebConsumer.moduloIA.IModuloIa, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class ModuloIaClient : System.ServiceModel.ClientBase<WebConsumer.moduloIA.IModuloIa>, WebConsumer.moduloIA.IModuloIa {
        
        public ModuloIaClient() {
        }
        
        public ModuloIaClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public ModuloIaClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ModuloIaClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ModuloIaClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public string tamanhoRede(int nivel, string user) {
            return base.Channel.tamanhoRede(nivel, user);
        }
        
        public System.Threading.Tasks.Task<string> tamanhoRedeAsync(int nivel, string user) {
            return base.Channel.tamanhoRedeAsync(nivel, user);
        }
        
        public string redeNivel(int nivel, string user) {
            return base.Channel.redeNivel(nivel, user);
        }
        
        public System.Threading.Tasks.Task<string> redeNivelAsync(int nivel, string user) {
            return base.Channel.redeNivelAsync(nivel, user);
        }
        
        public string amigosTag(string user, string tags) {
            return base.Channel.amigosTag(user, tags);
        }
        
        public System.Threading.Tasks.Task<string> amigosTagAsync(string user, string tags) {
            return base.Channel.amigosTagAsync(user, tags);
        }
        
        public string sugerirAmigos(string user) {
            return base.Channel.sugerirAmigos(user);
        }
        
        public System.Threading.Tasks.Task<string> sugerirAmigosAsync(string user) {
            return base.Channel.sugerirAmigosAsync(user);
        }
        
        public string maven(string tag) {
            return base.Channel.maven(tag);
        }
        
        public System.Threading.Tasks.Task<string> mavenAsync(string tag) {
            return base.Channel.mavenAsync(tag);
        }
        
        public string amigosComuns(string user1, string user2) {
            return base.Channel.amigosComuns(user1, user2);
        }
        
        public System.Threading.Tasks.Task<string> amigosComunsAsync(string user1, string user2) {
            return base.Channel.amigosComunsAsync(user1, user2);
        }
        
        public string caminhoForte(string userOrigem, string userDestino) {
            return base.Channel.caminhoForte(userOrigem, userDestino);
        }
        
        public System.Threading.Tasks.Task<string> caminhoForteAsync(string userOrigem, string userDestino) {
            return base.Channel.caminhoForteAsync(userOrigem, userDestino);
        }
        
        public string caminhoCurto(string userOrigem, string userDestino) {
            return base.Channel.caminhoCurto(userOrigem, userDestino);
        }
        
        public System.Threading.Tasks.Task<string> caminhoCurtoAsync(string userOrigem, string userDestino) {
            return base.Channel.caminhoCurtoAsync(userOrigem, userDestino);
        }
        
        public string grauMedioSeparacao() {
            return base.Channel.grauMedioSeparacao();
        }
        
        public System.Threading.Tasks.Task<string> grauMedioSeparacaoAsync() {
            return base.Channel.grauMedioSeparacaoAsync();
        }
        
        public string grafoNivel3(string user) {
            return base.Channel.grafoNivel3(user);
        }
        
        public System.Threading.Tasks.Task<string> grafoNivel3Async(string user) {
            return base.Channel.grafoNivel3Async(user);
        }
        
        public string traduzir(string orig) {
            return base.Channel.traduzir(orig);
        }
        
        public System.Threading.Tasks.Task<string> traduzirAsync(string orig) {
            return base.Channel.traduzirAsync(orig);
        }
        
        public string debug() {
            return base.Channel.debug();
        }
        
        public System.Threading.Tasks.Task<string> debugAsync() {
            return base.Channel.debugAsync();
        }
    }
}
