//
//  ViewController.swift
//  MyCamera
//
//  Created by 田中勇輝 on 2020/12/19.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var originalImage :UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var pictureImage: UIImageView!
    
    // カメラかフォトライブラリか選択
    @IBAction func chooseButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title:"確認",message:"選択してください",preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title:"カメラ",style:.default,handler: {(action:UIAlertAction) in
                // カメラが使用可能かを判断
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    // カメラ起動
                    let ipc = UIImagePickerController()
                    ipc.sourceType = UIImagePickerController.SourceType.camera
                    ipc.delegate = self
                    self.present(ipc,animated: true,completion: nil)
                }
            })
            alertController.addAction(cameraAction)
        }else{
            print("カメラは利用できません")
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoAction = UIAlertAction(title:"フォトライブラリ",style:.default,handler: {(action:UIAlertAction) in
                // フォトライブラリが使用可能かを判断
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    // フォトライブラリ起動
                    let ipc = UIImagePickerController()
                    ipc.sourceType = UIImagePickerController.SourceType.photoLibrary
                    ipc.delegate = self
                    self.present(ipc,animated: true,completion: nil)
                }
            })
            alertController.addAction(photoAction)
        }else{
            print("フォトライブラリは利用できません")
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController,animated: true , completion: nil)
    }
    
    // 撮影が終了した時に実行される
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        pictureImage.image = info[UIImagePickerController.InfoKey(rawValue:
        UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        originalImage = pictureImage.image!
        dismiss(animated: true, completion: nil)
    }
    
    // Imageを保存する
    @IBAction func saveImageButtonAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(pictureImage.image!, self, #selector(image(_:didFinishSavingWithError2:contextInfo:)), nil)
    }
    
    // エフェクト変更
    let filters = [
        "CIPhotoEffectMono",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess"
    ]
    var count = 0
    
    @IBAction func effectButtonTapped(_ sender: Any) {
        //オリジナル画像の退避
        var effectImage = originalImage
        //元画像の回転角度を取得
        let rotate = effectImage!.imageOrientation
        //UIImage形式の画像をCIImage形式の画像に変換
        let inputImage = CIImage(image: effectImage!)
        //引数で指定されたフィルタの種類を指定してCIFilterインスタンスを取得
        let effectFilter:CIFilter! = CIFilter(name: filters[count % 6])
        //エフェクトパラメータを初期化
        effectFilter.setDefaults()
        //インスタンスにエフェクトする元画像を設定
        effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
        //エフェクト後のCIImage形式の画像を取り出す
        let outputImage:CIImage! = effectFilter.outputImage
        //CIContextのインスタンスを取得。画像を加工するための領域を確保
        let ciContext = CIContext(options: nil)
        //エフェクト後の画像をCIContext上に描画し、結果をcgImageとして CGImage形式の画像を取得
        let cgImage = ciContext.createCGImage(outputImage,from: outputImage.extent)
        effectImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation: rotate)
        pictureImage.image = effectImage
        
        count = count + 1
    }
    
    // デフォルトに戻す
    @IBAction func defaultButtonTapped(_ sender: Any) {
        pictureImage.image = originalImage
        count = 0
    }
    
    
    
    // 保存が完了実行
    @objc func image(_ image: UIImage, didFinishSavingWithError2 error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "保存しました", message: "フォトアルバムを確認してください", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "保存出来ませんでした", message:
            error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    
}

