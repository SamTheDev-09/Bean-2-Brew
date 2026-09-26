function GallerySection() {
  const galleryImages = [
    { src: '/img/gallery-01.svg', alt: 'Bean 2 Brew interior with cozy seating' },
    { src: '/img/gallery-02.svg', alt: 'Latte with intricate foam art' },
    { src: '/img/gallery-03.svg', alt: 'Fresh pastries in the display case' },
    { src: '/img/gallery-04.svg', alt: 'Barista pouring espresso shot' },
    { src: '/img/gallery-05.svg', alt: 'Exterior storefront on Maple Street' },
    { src: '/img/gallery-06.svg', alt: 'Window seat overlooking Riverside Corner' }
  ]

  return (
    <section id="gallery" className="scroll-mt-20 py-16 px-4">
      <div className="container mx-auto max-w-6xl">
        <h2 className="text-4xl md:text-5xl font-display font-semibold text-espresso text-center mb-12">
          A Look Inside
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {galleryImages.map((image, index) => (
            <div
              key={index}
              className="relative aspect-square overflow-hidden rounded-lg shadow-lg hover:shadow-xl transition-shadow"
            >
              <img
                src={image.src}
                alt={image.alt}
                className="w-full h-full object-cover"
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

export default GallerySection
