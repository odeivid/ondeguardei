//
//  FuncoesGerais.swift
//  OndeGuardei
//
//  Created by DEIVID LOUREIRO on 11/03/17.
//  Copyright © 2017 DEIVID LOUREIRO. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class FuncoesGerais {
    
    //Dicionario com os campos de ordenação. É salvo o index no userDefault
    let objetoOrdenacaoLista: [Int:[String]] = [
        0 : ["objeto","Objeto"],
        1 : ["localizacao","Localização"]]
        
    
    let ud_AppLaunchOnce = "UD_AppLaunchOnce"
    let ud_ObjetoOrdenacaoIndex = "UD_RevisitaOrdenacaoIndex"
    
    let segundosDia: TimeInterval = 86400
    
    
    //MARK: - USER DEFAULTS / AJUSTES
    
    func carregarConfiguracoesIniciais() {
        self.setObjetoOrdenacao(valor: 0)
        
    }
    
    func appHasLaunchOnde() -> Bool {
        if UserDefaults.standard.object(forKey: self.ud_AppLaunchOnce) != nil{
            return true
        }
        
        UserDefaults.standard.set(true, forKey: self.ud_AppLaunchOnce)
        
        return false
    }
    
    func setObjetoOrdenacao(valor: Int) {
        UserDefaults.standard.set(valor, forKey: self.ud_ObjetoOrdenacaoIndex)
        UserDefaults.standard.synchronize()
    }
    
    func getObjetoOrdenacao() -> Int {
        if let valorRecuperado = UserDefaults.standard.object(forKey: self.ud_ObjetoOrdenacaoIndex){
            return valorRecuperado as! Int
        }else{
            self.setObjetoOrdenacao(valor: 0)
            return 0
        }
    }
    
    func getRevisitaOrdenacaoTitulos() -> [String] {
        var resultado: [String] = []
        
        for (_, value) in self.objetoOrdenacaoLista.sorted(by: {$0.0 < $1.0}) {
            resultado.append(value[1])
        }
        
        return resultado
    }
        // MARK: - Datas
    
    func converterDataParaString(data: Date!, style: DateFormatter.Style) -> String {
        
        if data == nil{
            return ""
        }
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = style
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        return formatterDate.string(from: data)
        
        
        //converte a string em data
        //print(formatterDate.date(from: self.txtProximaVisita.text!) as Any)
    }
    
    func converterDataParaString(data: NSDate!, style: DateFormatter.Style) -> String{
        if data == nil{
            return ""
        }
        
        return self.converterDataParaString(data: data as Date, style: style)
    }
    
    func converterDataParaString(data: NSDate!, formato: String) -> String
    {
        if data == nil || formato == ""{
            return ""
        }
        
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = formato
        return formatterDate.string(from: data as Date)
        
    }
    
    func converterStringParaData(data: String!, style: DateFormatter.Style) -> Date! {
        
        if data == nil || data == ""{
            return nil
        }
        
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = style
        formatterDate.timeStyle = .short
        //coloca o mês com 3 letras
        formatterDate.dateFormat = formatterDate.dateFormat.replacingOccurrences(of: "MMMM", with: "MMM")
        return formatterDate.date(from: data)!
        
    }
    
    func compararDatasSemTime(data1: Date, data2: Date) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        return dateFormatter.string(from: data1) == dateFormatter.string(from: data2)
        
    }
    
    func getDataInicioDia(data: Date) -> Date {
        
        let calendar = NSCalendar.current
        //calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone //OR NSTimeZone.localTimeZone()
        return calendar.startOfDay(for: data)
    }
    
    func getDataFimDia(data: Date) -> Date {
        let inicioDia = self.getDataInicioDia(data: data)
        return Date(timeInterval: self.segundosDia - 1, since: inicioDia)
    }
    
    
    // MARK: - Outros
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) (\(build))"
    }
    
    func mostrarAlertaSimples(titulo: String, mensagem: String) -> UIAlertController {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        let acaoOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alerta.addAction(acaoOK)
        
        return alerta
    }
    
    func sombraButton(botao: UIButton) {
        botao.layer.shadowColor = UIColor.black.cgColor
        botao.layer.shadowOffset = CGSize(width: 3, height: 3)
        botao.layer.shadowRadius = 5
        botao.layer.shadowOpacity = 0.3
    }
    
    
    func setTitleInNavigation(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        // titleLabel.textColor = UIColor.gray
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        //subtitleLabel.textColor = UIColor.black
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = frame.integral
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = frame.integral
        }
        
        return titleView
    }
    
    // MARK: - Arquivos
    
    func arquivoRemover(url: URL) -> Bool {
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
            return true
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return false
        }
    }
    
    func arquivoRemover(urlPath: String) -> Bool {
        
        let url = URL(fileURLWithPath: urlPath)
        
        return self.arquivoRemover(url: url)
    }
    
    
    func arquivoListarDocumentDirectory(filtroExtensao: String) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            //print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == filtroExtensao }
            //print("urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("list:", mp3FileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    func arquivoRemoverTodosDocumentDirectory(filtroExtensao: String) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            // if you want to filter the directory contents you can do like this:
            let files = directoryContents.filter{ $0.pathExtension == filtroExtensao }
            
            for file in files{
                _ = self.arquivoRemover(url: file)
            }
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func getGravacaoDataArquivoCriado(path: String) -> Date? {
        
        // Create a FileManager instance
        let fileManager = FileManager.default
        
        // Get attributes of file
        do {
            
            let attributes = try fileManager.attributesOfItem(atPath: path)
            
            let dateCreated = attributes[FileAttributeKey.creationDate] as! Date
            
            return dateCreated
            
            //return funcoesGerais.converterDataParaString(data: dateCreated, style: .medium)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return nil
        }
    }
    
    //retorna o nome do arquivo em string
    func getGravacaoDataArquivoCriado(path: String, style: DateFormatter.Style = .medium) -> String {
        
        if let data = self.getGravacaoDataArquivoCriado(path: path){
            return self.converterDataParaString(data: data, style: style)
        }
        
        return ""
    }
    
    
    // MARK: - Permissões
    
    func solicitarPermissaoUsoMicrofone() -> UIAlertController! {
        
        
        let alerta = UIAlertController(title: "Permissão do uso do microfone", message: "Necessário a permissão do uso do microfone para usar o fazer gravações", preferredStyle: .alert)
        
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        let acaoConfig = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfig) in
            
            if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.open(configuracoes as URL)
            }
        })
        
        alerta.addAction(acaoCancelar)
        alerta.addAction(acaoConfig)
        
        return alerta
        
    }
    
    // MARK: - 3D Touch / Shortcuts
    
    func criarShortcutProximaVisita() {
        
        /*if let revisita = CoreDataRevisita().getRevisitaProxima(){
            
            let horario = self.converterDataParaString(data: revisita.dataProximaVisita, style: .short)
            
            let firstIcon = UIApplicationShortcutIcon(type: .time)
            
            let firstItem = UIApplicationShortcutItem(type: "com.deivid.Ministerio.AbrirProximaRevisita", localizedTitle: revisita.nome!, localizedSubtitle: horario, icon: firstIcon, userInfo: nil)
            
            UIApplication.shared.shortcutItems = [firstItem]
        }*/
    }
    
    
    //Sportlight
    
    func spotlightIndexItem(title: String, desc: String, identifier: String) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = title
        attributeSet.contentDescription = desc
        
        let item = CSSearchableItem(uniqueIdentifier: "\(identifier)", domainIdentifier: "com.deivid.OndeGuardei", attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }
    
    
    func spotlightDeindex(item: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [item]) { error in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully removed!")
            }
        }
    }
    
    func spotlightDeleteAllItems() {
        CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)
        
    }
    
    
}
