function VisitUs() {
  return (
    <section id="visit" className="scroll-mt-20 py-16 px-4 bg-cream">
      <div className="container mx-auto max-w-6xl">
        <h2 className="text-4xl md:text-5xl font-display font-semibold text-espresso text-center mb-12">
          Come Say Hi
        </h2>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
          {/* Contact info */}
          <div className="space-y-6">
            <div>
              <h3 className="text-xl font-display font-semibold text-espresso mb-2">Address</h3>
              <p className="text-lg text-espresso/80">
                142 Maple Street<br />
                Riverside Corner, Springfield, IL 62704
              </p>
            </div>

            <div>
              <h3 className="text-xl font-display font-semibold text-espresso mb-2">Phone</h3>
              <a href="tel:+15552012837" className="text-lg text-terracotta hover:text-espresso">
                (555) 201-2837
              </a>
            </div>

            <div>
              <h3 className="text-xl font-display font-semibold text-espresso mb-2">Hours</h3>
              <p className="text-lg text-espresso/80">
                Mon–Fri 7:00am–7:00pm<br />
                Sat–Sun 8:00am–8:00pm
              </p>
            </div>

            <a
              href="https://www.google.com/maps/search/?api=1&query=142%20Maple%20Street%2C%20Riverside%20Corner%2C%20Springfield%2C%20IL%2062704"
              target="_blank"
              rel="noopener"
              className="inline-block px-8 py-3 bg-terracotta text-cream rounded-full font-medium hover:bg-espresso transition-colors"
            >
              Get Directions
            </a>
          </div>

          {/* Map */}
          <div className="rounded-lg overflow-hidden shadow-lg">
            <iframe
              src="https://www.openstreetmap.org/export/embed.html?bbox=-89.6551%2C39.7767%2C-89.6451%2C39.7867&layer=mapnik&marker=39.7817%2C-89.6501"
              title="Map to Bean 2 Brew"
              className="w-full h-[360px]"
              style={{ border: 0 }}
              allowFullScreen
              loading="lazy"
            ></iframe>
          </div>
        </div>
      </div>
    </section>
  )
}

export default VisitUs
