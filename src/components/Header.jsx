import { useState } from 'react'

function Header() {
  const [menuOpen, setMenuOpen] = useState(false)

  return (
    <header className="sticky top-0 z-50 bg-cream">
      <div className="container mx-auto px-4 py-4 flex items-center justify-between">
        <a href="#top" className="text-2xl font-display font-semibold text-espresso">
          Bean 2 Brew
        </a>

        {/* Desktop nav */}
        <nav className="hidden lg:flex items-center gap-8" aria-label="Main">
          <a href="#menu" className="text-espresso hover:text-terracotta">Menu</a>
          <a href="#story" className="text-espresso hover:text-terracotta">Our Story</a>
          <a href="#gallery" className="text-espresso hover:text-terracotta">Gallery</a>
          <a href="#visit" className="text-espresso hover:text-terracotta">Visit Us</a>
          <a href="#contact" className="text-espresso hover:text-terracotta">Contact</a>
          <a href="#visit" className="inline-block px-6 py-2 bg-terracotta text-cream rounded-full hover:bg-espresso">
            Visit Us Today
          </a>
        </nav>

        {/* Mobile hamburger */}
        <button
          className="lg:hidden w-11 h-11 flex items-center justify-center"
          aria-label="Open menu"
          onClick={() => setMenuOpen(true)}
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <line x1="3" y1="6" x2="21" y2="6" />
            <line x1="3" y1="12" x2="21" y2="12" />
            <line x1="3" y1="18" x2="21" y2="18" />
          </svg>
        </button>
      </div>

      {/* Mobile overlay */}
      {menuOpen && (
        <div className="fixed inset-0 z-50 bg-cream">
          <div className="container mx-auto px-4 py-4">
            <div className="flex justify-between items-center mb-12">
              <span className="text-2xl font-display font-semibold text-espresso">Bean 2 Brew</span>
              <button
                className="w-11 h-11 flex items-center justify-center"
                aria-label="Close menu"
                onClick={() => setMenuOpen(false)}
              >
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <line x1="18" y1="6" x2="6" y2="18" />
                  <line x1="6" y1="6" x2="18" y2="18" />
                </svg>
              </button>
            </div>
            <nav className="flex flex-col gap-6">
              <a
                href="#menu"
                className="text-2xl text-espresso hover:text-terracotta py-2"
                onClick={() => setMenuOpen(false)}
              >
                Menu
              </a>
              <a
                href="#story"
                className="text-2xl text-espresso hover:text-terracotta py-2"
                onClick={() => setMenuOpen(false)}
              >
                Our Story
              </a>
              <a
                href="#gallery"
                className="text-2xl text-espresso hover:text-terracotta py-2"
                onClick={() => setMenuOpen(false)}
              >
                Gallery
              </a>
              <a
                href="#visit"
                className="text-2xl text-espresso hover:text-terracotta py-2"
                onClick={() => setMenuOpen(false)}
              >
                Visit Us
              </a>
              <a
                href="#contact"
                className="text-2xl text-espresso hover:text-terracotta py-2"
                onClick={() => setMenuOpen(false)}
              >
                Contact
              </a>
              <a
                href="#visit"
                className="inline-block px-8 py-3 bg-terracotta text-cream rounded-full text-center mt-4 hover:bg-espresso"
                onClick={() => setMenuOpen(false)}
              >
                Visit Us Today
              </a>
            </nav>
          </div>
        </div>
      )}
    </header>
  )
}

export default Header
