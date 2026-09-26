function Hero() {
  return (
    <section id="hero" className="relative min-h-screen flex items-center justify-center overflow-hidden">
      {/* Background */}
      <div className="absolute inset-0">
        <img
          src="/img/hero-bg.svg"
          alt=""
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-espresso/40 to-espresso/60"></div>
      </div>

      {/* 3D mount point for Phase 3 */}
      <div id="hero-stage" aria-hidden="true" className="absolute inset-0"></div>

      {/* Content */}
      <div className="relative z-10 text-center px-4 max-w-4xl">
        <h1 className="text-5xl md:text-7xl font-display font-semibold text-cream mb-6">
          Slow Mornings, Made Right.
        </h1>
        <p className="text-xl md:text-2xl text-cream/90 mb-8 max-w-2xl mx-auto">
          Small-batch coffee, baked fresh daily, poured with care in the heart of Riverside Corner.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <a
            href="#menu"
            className="inline-block px-8 py-4 bg-terracotta text-cream rounded-full text-lg font-medium hover:bg-cream hover:text-espresso transition-colors"
          >
            See Our Menu
          </a>
          <a
            href="#visit"
            className="inline-block px-8 py-4 bg-transparent border-2 border-cream text-cream rounded-full text-lg font-medium hover:bg-cream hover:text-espresso transition-colors"
          >
            Get Directions
          </a>
        </div>
      </div>

      {/* Scroll cue */}
      <div className="absolute bottom-8 left-1/2 -translate-x-1/2 animate-bounce">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="text-cream">
          <polyline points="6 9 12 15 18 9"></polyline>
        </svg>
      </div>
    </section>
  )
}

export default Hero
