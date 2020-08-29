//
//  AddEditConsoleViewController.swift
//  MyGames
//
//  Created by aluno on 27/08/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit
import Photos

class AddEditConsoleViewController: UIViewController {

    //
    //  AddEditViewController.swift
    //  MyGames
    //
    //  Created by Douglas Frari on 8/24/20.
    //  Copyright © 2020 CESAR School. All rights reserved.
    //

        @IBOutlet weak var tfTitle: UITextField!
        @IBOutlet weak var tfConsole: UITextField!
        @IBOutlet weak var dpReleaseDate: UIDatePicker!
        @IBOutlet weak var btAddEdit: UIButton!
        @IBOutlet weak var btCover: UIButton!
        @IBOutlet weak var ivCover: UIImageView!
        
        // tip. Lazy somente constroi a classe quando for usar
        lazy var pickerView: UIPickerView = {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = .white
            return pickerView
        }()
        
        
        // recomenda-se declarar como Optional - quando tem o ponto de interrogacao (?)
        var console: Console?
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tfConsole.borderStyle = .none
            ConsolesManager.shared.loadConsoles(with: context)
        }
        

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // precisamos saber se estamos CRIANDO algo NOVO ou editando algo existente.
            // Faremos essa lógica aqui.
            prepareDataLayout()
        }
        
        func prepareDataLayout() {
            if console != nil {
                title = "Editar Console"
                btAddEdit.setTitle("ALTERAR", for: .normal)
                tfTitle.text = console?.name
                
                // tip. alem do console pegamos o indice atual para setar o picker view
//                if let console = console?.console, let index = ConsolesManager.shared.consoles.firstIndex(of: console) {
//                    tfConsole.text = console.name
//                    pickerView.selectRow(index, inComponent: 0, animated: false)
//                }
                
                ivCover.image = console?.cover as? UIImage
                if let releaseDate = console?.releaseDate {
                    dpReleaseDate.date = releaseDate
                }
                if console?.cover != nil {
                    btCover.setTitle(nil, for: .normal)
                }
            }
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
            toolbar.tintColor = UIColor(named: "main")
            let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [btCancel, btFlexibleSpace, btDone]
            
            // tip. faz o text field exibir os dados predefinidos pela picker view
            tfConsole.inputView = pickerView
            tfConsole.inputAccessoryView = toolbar
        }
        
        @objc func cancel() {
            tfConsole.resignFirstResponder()
        }
        
        @objc func done() {
            // pega o valor da PickerView e joga no campo Text Field da plataforma
            tfConsole.text = ConsolesManager.shared.consoles[pickerView.selectedRow(inComponent: 0)].name
            cancel()
        }
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        
        
        @IBAction func AddEditCover(_ sender: UIButton) {
            // para adicionar uma imagem da biblioteca
            
            // para adicionar uma imagem da biblioteca
            print("para adicionar uma imagem da biblioteca")
            
            
            let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
            
            let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
                self.selectPicture(sourceType: .photoLibrary)
            })
            alert.addAction(libraryAction)
            
            let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
                self.selectPicture(sourceType: .savedPhotosAlbum)
            })
            alert.addAction(photosAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
        
        
        func selectPicture(sourceType: UIImagePickerController.SourceType) {
            
            //Photos
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        
                        self.chooseImageFromLibrary(sourceType: sourceType)
                        
                    } else {
                        
                        print("unauthorized -- TODO message")
                    }
                })
            } else if photos == .authorized {
                
                self.chooseImageFromLibrary(sourceType: sourceType)
            }
        }
        
        
        func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
            
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = sourceType
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.tintColor = UIColor(named: "main")
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        
        
        @IBAction func addEditGame(_ sender: UIButton) {
            // acao salvar novo ou editar existente
            print("addEditConsole")
            
            
            if console == nil {
                console = Console(context: context)
            }
            console?.name = tfTitle.text
            console?.releaseDate = dpReleaseDate.date
            
//            if !tfConsole.text!.isEmpty {
//                let console = ConsolesManager.shared.consoles[pickerView.selectedRow(inComponent: 0)]
//                console?.console = console
//            }
            console?.cover = ivCover.image
            
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            // Back na navigation
            navigationController?.popViewController(animated: true)
            
        }

    } // fim da classe


    extension AddEditConsoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
       
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
       
       
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return ConsolesManager.shared.consoles.count
        }
       
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let console = ConsolesManager.shared.consoles[row]
            return console.name
        }
    }


    extension AddEditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            // fechar a janela
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                // ImageView won't update with new image
                // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
                DispatchQueue.main.async {
                    self.ivCover.image = pickedImage
                    self.ivCover.setNeedsDisplay()
                    self.btCover.setTitle(nil, for: .normal)
                    self.btCover.setNeedsDisplay()
                }
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
