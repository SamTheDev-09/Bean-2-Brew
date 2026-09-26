function StorySection() {
  return (
    <section id="story" className="scroll-mt-20 py-16 px-4 bg-cream">
      <div className="container mx-auto max-w-6xl">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Text content */}
          <div>
            <h2 className="text-4xl md:text-5xl font-display font-semibold text-espresso mb-6">
              Why We Started Pouring
            </h2>
            <div className="space-y-4 text-lg text-espresso/80">
              <p>
                We opened Bean 2 Brew in 2019 because Riverside Corner didn't have a neighborhood spot first, coffee shop second. A place where you could work on your laptop for hours without guilt, or just drop in for a pastry and leave. Where the barista knows your order but doesn't make a thing of it.
              </p>
              <p>
                Everything's made or roasted in-house or down the block. The playlist is never too loud. The bathroom's always clean. We're not trying to be the next big chain — we just want to be your regular spot.
              </p>
            </div>

            {/* Stats row */}
            <div className="flex flex-wrap gap-8 mt-8 text-espresso">
              <div>
                <div className="text-2xl font-display font-semibold">Est. 2019</div>
              </div>
              <div className="border-l-2 border-espresso/20 pl-8">
                <div className="text-2xl font-display font-semibold">Locally Roasted</div>
              </div>
              <div className="border-l-2 border-espresso/20 pl-8">
                <div className="text-2xl font-display font-semibold">Family Owned</div>
              </div>
            </div>
          </div>

          {/* Image */}
          <div className="rounded-lg overflow-hidden shadow-lg">
            <img
              src="/img/story-space.svg"
              alt="The Bean 2 Brew space in Riverside Corner"
              className="w-full h-full object-cover"
            />
          </div>
        </div>
      </div>
    </section>
  )
}

export default StorySection
