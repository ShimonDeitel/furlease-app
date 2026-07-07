import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.accent)
                Text("Furlease Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.textPrimary)
                Text("Document storage for lease pet addendums and move-out photos")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                if let product = purchases.product {
                    Text(product.displayPrice)
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textPrimary)
                } else {
                    Text("one-time purchase")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textPrimary)
                }
                Button {
                    Task { await purchases.purchase() }
                } label: {
                    Text("Unlock Pro")
                        .font(Theme.bodyFont.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .accessibilityIdentifier("unlockProButton")
                .padding(.horizontal)
                Button("Not Now") { dismiss() }
                    .accessibilityIdentifier("paywallDismissButton")
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding()
        }
    }
}
