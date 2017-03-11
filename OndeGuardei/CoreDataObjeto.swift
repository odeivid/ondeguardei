//
//  CoreDataObjeto.swift
//  OndeGuardei
//
//  Created by DEIVID LOUREIRO on 11/03/17.
//  Copyright © 2017 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import CoreData

class CoreDataObjeto {
    
    let dateFormatToID: String = "YYYYMMdd-HH:DD:ss.SSSS"

    
    lazy var ordenacaoCampo: String = {
        let funcoesGerais = FuncoesGerais()
        
        return funcoesGerais.objetoOrdenacaoLista[funcoesGerais.getObjetoOrdenacao()]![0]
    }()
    
    //recuperar contexto
    func getContext() -> NSManagedObjectContext{
        return ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    }
    
    func gerarID(data: Date) -> String {
        return FuncoesGerais().converterDataParaString(data: data as NSDate!, formato: "YYYYMMDD")
    }
    
    
    func getObjetoById(id: String) -> ObjetoGuardado? {
        do{
            let requisicao = ObjetoGuardado.fetchRequest() as NSFetchRequest<ObjetoGuardado>
            requisicao.predicate = NSPredicate(format: "id = %@", id)
            
            let objetos = try self.getContext().fetch(requisicao) as [ObjetoGuardado]
            if objetos.count > 0{
                return objetos.first!
            }
            return nil
        }catch{
            return nil
        }
        
    }

    
    func getObjetos(favoritoSimNao: Bool = false) -> [ObjetoGuardado] {
        
        do{
            let requisicao = ObjetoGuardado.fetchRequest() as NSFetchRequest<ObjetoGuardado>
            requisicao.predicate = NSPredicate(format: "favoritoSimNao = %@", favoritoSimNao as CVarArg)
            
            var ordenacaoAZ: [NSSortDescriptor] = []
            
            if self.ordenacaoCampo == "dataProximaVisita"{
                let ordenacaoAux = NSSortDescriptor(key: "dataProximaVisitaSimNao", ascending: false)
                ordenacaoAZ.append(ordenacaoAux)
            }
            
            let ordenacaoPadrao = NSSortDescriptor(key: self.ordenacaoCampo, ascending: true)
            ordenacaoAZ.append(ordenacaoPadrao)
            
            requisicao.sortDescriptors = ordenacaoAZ
            
            return try self.getContext().fetch(requisicao) as [ObjetoGuardado]
        }catch{
            return []
        }
    }

    
    func getObjetos(favoritoSimNao: Bool, objeto: String, localizacao: String) -> [ObjetoGuardado] {
        
        do{
            let requisicao = ObjetoGuardado.fetchRequest() as NSFetchRequest<ObjetoGuardado>
            requisicao.predicate = NSPredicate(format: "favoritoSimNao = %@ AND (objeto contains [c] %@ OR localizacao contains [c] %@)", favoritoSimNao as CVarArg, objeto, localizacao)
            
            let ordenacaoAZ = NSSortDescriptor(key: self.ordenacaoCampo, ascending: true)
            requisicao.sortDescriptors = [ordenacaoAZ]
            
            return try self.getContext().fetch(requisicao) as [ObjetoGuardado]
        }catch{
            return []
        }
    }
    
    func salvarObjetoGuardado(objetoGuardado: ObjetoGuardado) {
        do{
            let contexto = self.getContext()
            
            contexto.insert(objetoGuardado as NSManagedObject)
            
            try contexto.save()
            
        }catch{
            
        }
    }
    
    func criarObjetoRevisitaNoContexto(inserirNovoRegistroSimNao: Bool, objetoGuardado: ObjetoGuardado, objeto: String, localizacao: String, favoritoSimNao: Bool, foto: Data?) -> ObjetoGuardado {
        
        let objetoGuardado = ObjetoGuardado(context: getContext())
        let data = NSDate()
        
        objetoGuardado.id = FuncoesGerais().converterDataParaString(data: data, formato: self.dateFormatToID)
        objetoGuardado.objeto = objeto
        objetoGuardado.localizacao = localizacao
        objetoGuardado.data = data
        objetoGuardado.favoritoSimNao = favoritoSimNao
        objetoGuardado.foto = foto as NSData?
        
        if inserirNovoRegistroSimNao == true{
            self.salvarObjetoGuardado(objetoGuardado: objetoGuardado)
        }
        
        return objetoGuardado
    }
    
    func atualizarObjetoRevisitaNoContexto(objetoGuardado: ObjetoGuardado, objeto: String, localizacao: String, favoritoSimNao: Bool, foto: Data?) {
        
        objetoGuardado.objeto = objeto
        objetoGuardado.localizacao = localizacao
        objetoGuardado.data = NSDate()
        objetoGuardado.favoritoSimNao = favoritoSimNao
        objetoGuardado.foto = foto as NSData?
        
        do{
            try getContext().save()
        }catch{
            print("erro ao atualizar objeto")
        }
    }
    
    func objetoGuardadoFavoritar(objetoGuardado: ObjetoGuardado, favoritoSimNao: Bool) {
        
        objetoGuardado.favoritoSimNao = favoritoSimNao
        
        do{
            try getContext().save()
        }catch{
            print("erro ao atualizar Objeto Guardado")
        }
    }
    
    func removerRevisita(objeto: ObjetoGuardado) {
        do{
            let contexto = self.getContext()
            
            contexto.delete(objeto as NSManagedObject)
            
            try contexto.save()
            
        }catch{
            
        }
    }
    
}
