import SwiftUI

struct ImageView: View {
  let url: URL
  let queue: OperationQueue

  @State private var image = Image(systemName: "photo")

  var body: some View {
    image
      .resizable()
      .aspectRatio(contentMode: .fit)
      .task {
        tiltShiftImage()
      }
  }

  init(in queue: OperationQueue, for url: URL) {
    self.url = url
    self.queue = queue
  }

  private func tiltShiftImage() {
    let downloadOp = NetworkImageOperation(url: url)
    let op = TiltShiftOperation()
    op.addDependency(downloadOp)

    op.onImageProcessed = { uiImage in
      if let uiImage {
        image = Image(uiImage: uiImage)
      }
    }

    queue.addOperation(downloadOp)
    queue.addOperation(op)
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(in: OperationQueue(), for: URL(string: "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466780-jpeg.jpg")!)
  }
}
